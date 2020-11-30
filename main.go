package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

var (
	store PersistJsonnet
)

var epoch = time.Unix(0, 0).Format(time.RFC1123)

var noCacheHeaders = map[string]string{
	"Expires":         epoch,
	"Cache-Control":   "no-cache, private, max-age=0",
	"Pragma":          "no-cache",
	"X-Accel-Expires": "0",
}

var etagHeaders = []string{
	"ETag",
	"If-Modified-Since",
	"If-Match",
	"If-None-Match",
	"If-Range",
	"If-Unmodified-Since",
}

func NoCache(h http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		// Delete any ETag headers that may have been set
		for _, v := range etagHeaders {
			if r.Header.Get(v) != "" {
				r.Header.Del(v)
			}
		}

		// Set our NoCache headers
		for k, v := range noCacheHeaders {
			w.Header().Set(k, v)
		}

		h.ServeHTTP(w, r)
	}

	return http.HandlerFunc(fn)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	flag.Parse()

	// Add in toggle for the different types of backends
	store = InMemory{
		store: map[string]string{},
	}

	if store == nil {
		fmt.Println("A storage driver must be provided")
		os.Exit(1)
	}

	server := &http.Server{
		Handler: http.TimeoutHandler(http.DefaultServeMux, 7*time.Second, ""),
		Addr:    "localhost:" + port,
	}

	http.HandleFunc("/", HandleEditor)
	http.HandleFunc("/backend/share", HandleShare)
	http.HandleFunc("/backend/compile", HandleCompile)

	fileServer := http.FileServer(http.Dir("static"))
	http.Handle("/static/", NoCache(http.StripPrefix("/static/", fileServer)))

	log.Fatalf("Error listening on :%v: %v", port, server.ListenAndServe())
}
