self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  
  // Only intercept requests to mydeskmate.ai
  if (url.hostname === 'mydeskmate.ai') {
    event.respondWith(
      fetch(event.request, {
        mode: 'cors',
        credentials: 'include',
        headers: {
          'Origin': self.location.origin,
          'Access-Control-Request-Method': event.request.method,
          'Access-Control-Request-Headers': 'Content-Type, Accept'
        }
      }).catch(error => {
        console.error('Service worker fetch error:', error);
        return new Response(
          JSON.stringify({ error: 'Failed to fetch from API' }),
          { 
            status: 500,
            headers: { 'Content-Type': 'application/json' }
          }
        );
      })
    );
  }
});

// Install service worker
self.addEventListener('install', event => {
  self.skipWaiting();
});

// Activate service worker
self.addEventListener('activate', event => {
  event.waitUntil(clients.claim());
});
