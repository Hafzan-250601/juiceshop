pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        docker pull bkimminich/juice-shop
        '''
      }
    }
    stage('Scan image and upload findings to SecurityHub') {
      steps {
        sh '''
        trivy image --no-progress --severity HIGH,CRITICAL bkimminich/juice-shop
        '''
      }
    }
  }
}
