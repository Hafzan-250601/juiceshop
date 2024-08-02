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
    stage('Start the built docker images') {
      steps {
        sh '''
        docker run -e CONTRAST__API__URL=https://cs004.contrastsecurity.com/Contrast/api -e CONTRAST__API__API_KEY=0z5mjRvL3CIbY31ba4RJDhArXbAZw5KL -e CONTRAST__API__SERVICE_KEY=9PR72PEUJ3TKYOLA -e CONTRAST__API__USER_NAME=ailow@deloitte.com -p 3000:3000 juice-shop
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
  }
}
