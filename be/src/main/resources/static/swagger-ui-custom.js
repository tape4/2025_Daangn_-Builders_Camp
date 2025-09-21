// Auto-fill development token in Swagger UI
window.onload = function() {
    // Wait for Swagger UI to fully load
    setTimeout(function() {
        const devToken = document.querySelector('.scheme-description')?.textContent?.match(/eyJ[A-Za-z0-9\-_]+\.eyJ[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+/);
        if (devToken && devToken[0]) {
            console.log('Development token found, ready to use in Authorization');
            
            // Try to auto-fill when Authorize button is clicked
            document.querySelector('.authorize')?.addEventListener('click', function() {
                setTimeout(function() {
                    const tokenInput = document.querySelector('input[type="text"][placeholder*="Bearer"]') || 
                                      document.querySelector('input[aria-label*="auth-bearer-value"]') ||
                                      document.querySelector('.auth-container input[type="text"]');
                    if (tokenInput && !tokenInput.value) {
                        tokenInput.value = devToken[0];
                        tokenInput.dispatchEvent(new Event('input', { bubbles: true }));
                        console.log('Token auto-filled!');
                    }
                }, 100);
            });
        }
    }, 1000);
};