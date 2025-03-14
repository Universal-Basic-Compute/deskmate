self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  
  // Only intercept requests to mydeskmate.ai
  if (url.hostname === 'mydeskmate.ai') {
    event.respondWith(
      fetch(event.request.url, {
        method: event.request.method,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': self.location.origin,
          'mode': 'cors',
        },
        body: event.request.method !== 'GET' ? event.request.clone().body : undefined,
        mode: 'no-cors', // This is key - use no-cors mode
      }).then(response => {
        console.log('Service worker successfully intercepted request');
        return response;
      }).catch(error => {
        console.error('Service worker fetch error:', error);
        // Return a fallback response
        return new Response(
          JSON.stringify({ 
            response: "I'm sorry, I couldn't connect to my servers. Please check your internet connection and try again.",
            error: 'Failed to fetch from API' 
          }),
          { 
            status: 200, // Return 200 to avoid error in the app
            headers: { 'Content-Type': 'application/json' }
          }
        );
      })
    );
  }
});

// Install service worker
self.addEventListener('install', event => {
  console.log('Service worker installed');
  self.skipWaiting();
});

// Activate service worker
self.addEventListener('activate', event => {
  console.log('Service worker activated');
  event.waitUntil(clients.claim());
});
