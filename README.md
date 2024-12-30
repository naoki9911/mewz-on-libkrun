# mewz-on-libkrun
## Build and run with registry's image
```console
$ git clone --recursive http://github.com/naoki9911/mewz-on-libkrun
$ cd mewz-on-libkrun
$ docker run --rm -v $(pwd):/work ghcr.io/naoki9911/mewz-on-libkrun/mewz-on-libkrun:latest /work/build.sh
$ cd likbrun/examples
$ sudo LD_LIBRARY_PATH=../lib ./chroot_vm --net=passt dummy dummy

```
In another terminal,
```console
$ curl locahost:1234
Hello World!
```

## Build image
```console
$ docker build . -t ghcr.io/naoki9911/mewz-on-libkrun/mewz-on-libkrun:latest
```