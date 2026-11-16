// Keeps a copy of the app's own files on the device so it opens quickly.
// Change the version name whenever you update the app, so devices fetch the new files.
const CACHE = "stockroom-db-v1";
const FILES = ["./", "index.html", "manifest.webmanifest", "icon-192.png", "icon-512.png"];

self.addEventListener("install", function (event) {
  event.waitUntil(caches.open(CACHE).then(function (cache) { return cache.addAll(FILES); }));
  self.skipWaiting();
});

self.addEventListener("activate", function (event) {
  event.waitUntil(
    caches.keys().then(function (names) {
      return Promise.all(names.filter(function (n) { return n !== CACHE; }).map(function (n) { return caches.delete(n); }));
    })
  );
  self.clients.claim();
});

// Only the app's own files are handled here. Requests to the database and to other
// sites pass straight through untouched.
self.addEventListener("fetch", function (event) {
  if (event.request.method !== "GET") return;
  if (new URL(event.request.url).origin !== location.origin) return;
  event.respondWith(
    fetch(event.request).then(function (response) {
      if (response.ok) {
        const copy = response.clone();
        caches.open(CACHE).then(function (cache) { cache.put(event.request, copy); });
      }
      return response;
    }).catch(function () {
      return caches.match(event.request).then(function (hit) { return hit || caches.match("index.html"); });
    })
  );
});
