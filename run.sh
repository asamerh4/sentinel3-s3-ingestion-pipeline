#!/bin/bash
./tools/sentinel-3/s3_ingest_taskgroupinfo_gen.sh > tasklist
mesos-batch --master=$MESOS_MASTER:5050 --task_list=file:///root/tasklist --framework_name=$FRAMEWORK_NAME
