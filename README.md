# tailbench-in-container

build and run tailbench in container, inspired by [briankoco/tailbench-docker](https://github.com/briankoco/tailbench-docker)

## Component

- TailBench v0.9: apps and tools's source code and dependencies
- TailBench Datasets: realword workload dataset
- Dockerfile: build a compiling env container on centos
- docker-compose.yaml: run a building env container, build if image not found

after download all dependencies, the dir must be like follow:

```
├── docker-compose.yaml
├── Dockerfile
├── tailbench.inputs
└── tailbench-v0.9
```

## TailBench

you can download tailbench and datasets from [here](http://tailbench.csail.mit.edu/), but there may exist some bugs in tailbench, so you can clone from a fixed repo by:

```shell
$ git submodule update --init 
```

I have made some configs for building and running in container on branch nochrt, if you want to use the raw config just run:

```shell
$ cd tailbench-v0.9
$ git checkout main
```

## Container Env

if you have `docker-compose` installed, you can to build and run env container and mount tailbench onto it just by

```shell
# add `--build` to build image locally,
# `-d` means running backend
$ docker-compose up -d

# enter into container
$ docker exec -it tailbenchd-tailbenchenv-1 /bin/bash
```

but if you want to start step by step, you do as follow

```
$ make image
```

this will build a image base on centos7, and install nessessary packages as follow: 

```shell
make automake file \
gcc gcc-c++ \
java-1.8.0-openjdk java-1.8.0-openjdk-devel \
gperftools google-perftools \
libtool bison autoconf numpy scipy swig ant \
zlib-devel libuuid-devel opencv-devel jemalloc-devel numactl-devel \
libdb-cxx-devel libaio-devel openssl-devel readline-devel \
libgtop2-devel glib-devel boost-devel\
python python-devel python-pip
```

after all thinges done, you can run a container and start compling
- tailbench v0.9
- tailbench.inputs
- tailbenchenv:centos7

```shell
# flag `rm` will destroy container while existing, remove if you want to keep container remaining
$ docker run -it --rm -v ${PWD}/tailbench-v0.9:/src/tailbench -v ${PWD}/tailbench.inputs:/src/dataset faione/tailbenchenv:centos7 /bin/bash
```

## Build and Run

tailbench source code will mount at `/src/tailbench`, you can build by [BUILD-INSTRUCTIONS](https://github.com/Faione/tailbench/blob/main/BUILD-INSTRUCTIONS)

```shell
$ cd /src/tailbench

$ ./build.sh
```

each app has two scripts to run bench mark, to run all:

```shell
$ cd /src/tailbench

# sleep for bench to exit
$ for app in img-dnn masstree shore specjbb moses silo sphinx xapian;do \
  echo ${app}; \
  cd ${app};\
  ./run_networked.sh; \
  sleep 10; \
  cd -; \
  done;
```

check the result by:

```shell
$ for app in img-dnn masstree specjbb moses silo sphinx xapian;do \
  echo ${app}; \
  python utilities/parselats.py ${app}/lats.bin 95; \
  done;
```