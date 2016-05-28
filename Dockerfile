# Scala and sbt on Java 7
#
# URL: https://github.com/William-Yeh/docker-scala
#
# forked from: pulse00/scala
#              - https://index.docker.io/u/pulse00/scala/
#              - https://github.com/dubture-dockerfiles/scala
#
# Version     0.6

FROM williamyeh/java7
MAINTAINER Phirotto Main <phirotto@gmail.com>

ENV SCALA_TARBALL http://www.scala-lang.org/files/archive/scala-2.11.5.deb
ENV SBT_JAR       https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.7/sbt-launch.jar



RUN \
    echo "===> install from Typesafe repo (contains old versions but they have all dependencies we need later on)"  && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --force-yes wget  && \
    wget http://apt.typesafe.com/repo-deb-build-0002.deb  && \
    dpkg -i repo-deb-build-0002.deb  && \
    apt-get update  && \
    \
    \
    \
    echo "===> install Scala"  && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --force-yes libjansi-java  && \
    wget -nv $SCALA_TARBALL  && \
    dpkg -i scala-*.deb   && \
    \
    \
    \
    echo "===> install sbt"  && \
    wget -nv -P /usr/local/bin/  $SBT_JAR
#        && \
#    \
#    \
#    \
#    echo "===> clean up..."  && \
#    rm -f *.deb  && \
#    apt-get clean  && \
#    rm -rf /var/lib/apt/lists/*

# giter8 setup
RUN apt-get update && \
    apt-get -y install curl && \
    curl https://raw.githubusercontent.com/foundweekends/conscript/master/setup.sh | sh && \
    PATH=$PATH:~/bin && \
    export PATH && \
# RUN source ~/.bashrc 
    echo "source ~/.bashrc" >> /tmp/setup && \
    /bin/bash -C "/tmp/setup" && \
# RUN rm -f /tmp/setup
# RUN cs foundweekends/giter8
    echo "cs foundweekends/giter8" >> /tmp/setup && \
    /bin/bash -C "/tmp/setup" && \
    rm -f /tmp/setup

COPY sbt /usr/local/bin/

# create an empty sbt project;
# then fetch all sbt jars from Maven repo so that your sbt will be ready to be used when you launch the image
COPY test-sbt.sh /tmp/
RUN cd /tmp  && \
    ./test-sbt.sh   && \
    rm -rf *

# print versions
# RUN java -version

# scala -version returns code 1 instead of 0 thus "|| true"
# RUN scala -version || true

RUN \
   echo "===> clean up..."  && \
    rm -f *.deb  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*