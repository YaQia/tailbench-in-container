FROM centos:centos7

# update package
RUN yum -y install epel-release && yum -y update

# install dependencies
RUN yum install -y \
            make automake file \
            gcc gcc-c++ \
            java-1.8.0-openjdk java-1.8.0-openjdk-devel \
            gperftools google-perftools \
            libtool bison autoconf numpy scipy swig ant \
            zlib-devel libuuid-devel opencv-devel jemalloc-devel numactl-devel \
            libdb-cxx-devel libaio-devel openssl-devel readline-devel \
            libgtop2-devel glib-devel boost-devel\
            python python-devel python-pip

# link glibconfig.h to /usr/include, avoid compiling error
RUN ln -s /usr/lib64/glib-2.0/include/glibconfig.h  /usr/include/glib-2.0/

# mount for tailbench
RUN mkdir -p /src/scratch

ENTRYPOINT [""]
