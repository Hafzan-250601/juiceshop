pipeline {
  agent any
  stages {
    stage('Build and install Contrast Assess Agent') {
      steps {
        sh '''
        docker build -t juice-shop .
        '''
      }
    }
  stages {
    stage('Start the built docker images') {
      steps {
        sh '''
        docker run -e CONTRAST__API__URL=$CONTRAST__API__URL -e CONTRAST__API__API_KEY= $CONTRAST__API__API_KEY -e CONTRAST__API__SERVICE_KEY=$CONTRAST__API__SERVICE_KEY -e CONTRAST__API__USER_NAME=$CONTRAST__API__USER_NAME -p 3000:3000 juice-shop
        '''
      }
    }
    stage('Scan image using Trivy') {
      steps {
        sh '''
        trivy image --no-progress --severity HIGH,CRITICAL juice-shop
        '''
      }
    }
    stage('Scan image using Snyk') {
      steps {
        sh '''
        snyk-linux container monitor juice-shop --org=27b08c82-2fb9-4856-9b83-d2fcc25dcd66
        '''
      }
    }
  }
}
