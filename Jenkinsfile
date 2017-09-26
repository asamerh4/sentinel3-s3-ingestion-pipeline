pipeline {
  agent {
    docker {
      image 'asamerh4/sentinel3-s3-ingestion-pipeline:817ca0c'
      args '-u root'
    }
    
  }
  stages {
    stage('create taskgroupinfo from uuid-list') {
      steps {
        sh 'ls -l'
      }
    }
    stage('do the parallel processing [map]') {
      steps {
        parallel(
          "fmask mesos-batch": {
            sh 'ls -l'
            
          },
          "count S2-tiles": {
            sh 'ls -l'
            
          },
          "list mesos tasklist": {
            sh 'ls -ltr'
            
          }
        )
      }
    }
    stage('aggregate results [reduce]') {
      steps {
        sh 'ls -l'
      }
    }
  }
  environment {
    COMMAND = './run-fmask.sh'
    CPUS = '1.0'
    DOCKER_IMAGE = 'asamerh4/python-fmask:fmask0.4-aws-4cdfaf5'
    DOCKER_MEM = '12G'
    DOCKER_SWAP = '12G'
    MEM = '2000'
    S3_PREFIX = 'tiles/54/M/TA/2017/6/'
    SOURCE_BUCKET = 's2-sync'
    TARGET_BUCKET = 's2-derived'
    UNIQUE_FILE = 'metadata.xml'
    AWS_DEFAULT_REGION = 'eu-central-1'
    MESOS_MASTER = '174.0.1.80:5050'
    MESOS_FRAMEWORK_NAME = 'S2-fmaskd-Papua54MTA'
  }
}