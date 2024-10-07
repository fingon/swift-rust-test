# Swift + Rust test app #

This is mostly just an experiment to see what Rust backend would look like in a Swift app.

- backend/: Rust part of app (Makefile contains relevant utilities to build it)

- swift-go-test/: Swift app

Disclaimer: Speed results are with Macbook Pro (14" 2021 model with M1 Pro)

# How fast is it to build the backend from scratch? (3 arches)

## Default debug

```
mstenber@hana ~/projects/swift-rust-test/backend>time ./build.sh
./build.sh  155.63s user 13.62s system 432% cpu 39.165 total
```

## Default release

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

# How fast is incremental compilation? (debug build, with disk cache hot)

```
mstenber@hana ~/projects/swift-rust-test/backend>echo >> src/lib.rs
mstenber@hana ~/projects/swift-rust-test/backend>time ./build.sh
./build.sh  2.41s user 1.36s system 82% cpu 4.589 total
```


# How big is the result? (3 arches)

## Default debug

```
mstenber@hana ~/projects/swift-rust-test/backend>du -hs ../swift-rust-test/backend.xcframework
389M	../swift-rust-test/backend.xcframework
```

## Default release

```
mstenber@hana ~/projects/swift-rust-test/backend>du -hs ../swift-rust-test/backend.xcframework
 89M	../swift-rust-test/backend.xcframework
```


## Current release configuration (more optimized, slower)

```
mstenber@hana ~/projects/swift-rust-test/backend>du -hs ../swift-rust-test/backend.xcframework
 19M	../swift-rust-test/backend.xcframework
```


# See also

[Go version](https://github.com/fingon/swift-go-test)
