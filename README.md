# Packages cache

One proxy cache for all packages.

Specificities of `docker build` with cache are explained.

This configurations files are bare bone.
Do not use it in production as is.
Use YOUR settings, and test with YOUR projects to build.

## Demo time

Build nginx cache image and run it

```bash
make build-cache
make cache-server
```

Launch all demos in another terminal (maybe `tmux` ?)

```bash
make demo
```
