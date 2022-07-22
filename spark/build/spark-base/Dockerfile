FROM ubuntu:18.04 AS deps

RUN apt-get update && apt-get -y install wget
WORKDIR /tmp
RUN wget https://archive.apache.org/dist/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz \
	&& tar xvzf spark-3.2.1-bin-hadoop3.2.tgz 


# Runtime Container Image. Adapted from the official Spark runtime 
# image from the project repository at https://github.com/apache/spark.
FROM openjdk:8-jdk-slim AS build

# Spark UID
ARG spark_uid=185

# Install Spark Dependencies and Prepare Spark Runtime Environment
RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules libnss3 wget python3 python3-pip && \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    ln -sv /usr/bin/tini /sbin/tini && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    ln -sv /usr/bin/python3 /usr/bin/python && \
    ln -sv /usr/bin/pip3 /usr/bin/pip \
    rm -rf /var/cache/apt/*

# Install Kerberos Client and Auth Components
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt install -yqq krb5-user \
  && rm -rf /var/cache/apt/*


# Copy previously fetched runtime components
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/bin /opt/spark/bin
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/jars /opt/spark/jars
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/python /opt/spark/python
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/R /opt/spark/R
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/sbin /opt/spark/sbin
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/yarn /opt/spark/yarn

# Copy Docker entry script
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/kubernetes/dockerfiles/spark/entrypoint.sh /opt/

# COpy examples, data, and tests
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/examples /opt/spark/examples
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/data /opt/spark/data
COPY --from=deps /tmp/spark-3.2.1-bin-hadoop3.2/kubernetes/tests /opt/spark/tests

# Replace out of date dependencies causing a 403 error on job launch
WORKDIR /tmp
COPY ./spark-jars /tmp/spark-jars
RUN mv ./spark-jars/* /opt/spark/jars/


# Set Spark runtime options
ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}