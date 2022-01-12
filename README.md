# arm64-nacos
> ## Theme ideas
>
> Modify the base image/JDK environment/nacos attachment on the basis of the official original Dockerfile, and rebuild the image in the ARM environment

> ## Operating environment
```shell
$ lscpu
Architecture:          aarch64
Byte Order:            Little Endian
CPU(s):                2
On-line CPU(s) list:   0,1
Thread(s) per core:    1
Core(s) per socket:    2
Socket(s):             1
NUMA node(s):          1
Model:                 0
CPU max MHz:           2400.0000
CPU min MHz:           2400.0000
BogoMIPS:              200.00
L1d cache:             64K
L1i cache:             64K
L2 cache:              512K
L3 cache:              32768K
NUMA node0 CPU(s):     0,1
Flags:                 fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm jscvt fcma dcpop asimddp asimdfhm

$ cat /etc/redhat-release
CentOS Linux release 7.6.1810 (AltArch)

$ uname -r
4.18.0-80.7.2.el7.aarch64
```

> ## Operation process
```shell
# 1.Prepare the build environment
# Java env
# oracle jdk： https://www.oracle.com/java/technologies/downloads/#java8
https://www.oracle.com/java/technologies/downloads/#license-lightbox

# Maven env
https://mirrors.cnnic.cn/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz

# 2.Refresh environment variables
# /etc/profile
# MAVEN
export MAVEN_HOME=/usr/local/maven
export PATH=$PATH:$MAVEN_HOME/bin

# JAVA
export JAVA_HOME=/usr/share/jdk1.8.0_311/
export JRE_HOME=/usr/share/jdk1.8.0_311/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH


# 3.Download the source code
https://github.com/alibaba/nacos/archive/refs/tags/1.2.1.tar.gz

# 4.Source code compilation
# official doc： https://nacos.io/en-us/docs/quick-start.html
mvn  -Dmaven.test.skip=true clean install
mvn  -Dmaven.test.skip=true clean package
mvn -Prelease-nacos -Dmaven.test.skip=true clean install -U

# 5.Create an image build environment and make attachments 
$ mkdir -p docker && cd docker
$ cd  ../distribution/target/nacos-server-1.2.1.tar.gz/nacos 
$ tar -czvf nacos-server-1.2.1.tar.gz ./*


# 6.Download other attachments
#  bin/  conf/  init.d
https://codeload.github.com/nacos-group/nacos-docker/zip/refs/heads/1.2.1

# 7.Revise Dockerfile
# official Dockerfile： https://github.com/nacos-group/nacos-docker/blob/1.2.1/build/Dockerfile

# 8.Rebuild
```
