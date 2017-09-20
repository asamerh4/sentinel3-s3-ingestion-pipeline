FROM asamerh4/mesos-batch:f7ea7a1

MAINTAINER Hubert Asamer

COPY tools/ /root/tools/
COPY sentinel-3-uuid-list /root/sentinel-3-uuid-list

WORKDIR /root