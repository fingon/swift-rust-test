# Swift + Rust test app #

This is mostly just an experiment to see what Rust backend would look like in a Swift app.

- backend/: Rust part of app (Makefile contains relevant utilities to build it)

- swift-go-test/: Swift app

Disclaimer: Speed results are with Macbook Pro (14" 2021 model with M1 Pro)

# How fast is it to build the backend from scratch? (3 arches)

## Default

```
mstenber@hana ~/projects/swift-rust-test/backend>git clean -dfx .
mstenber@hana ~/projects/swift-rust-test/backend>time ./build.sh
./build.sh  396.73s user 15.84s system 502% cpu 1:22.15 total
```


## Current release configuration (more optimized, slower)

```
mstenber@hana ~/projects/swift-rust-test/backend>git clean -dfx .
mstenber@hana ~/projects/swift-rust-test/backend>time ./build.sh
./build.sh  294.49s user 14.31s system 217% cpu 2:21.75 total
```

# How big is the result? (3 arches)

## Default

```
mstenber@hana ~/projects/swift-rust-test/backend>du -hs ../swift-rust-test/backend.xcframework
 89M	../swift-rust-test/backend.xcframework
```


## Current release configuration (more optimized, slower)

```
mstenber@hana ~/projects/swift-rust-test/backend>du -hs ../swift-rust-test/backend.xcframework
 19M	../swift-rust-test/backend.xcframework
```
