pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        docker build -t juiceshop .
        '''
      }
    }
    stage('Scan image using Trivy') {
      steps {
        sh '''
        trivy image --no-progress --severity HIGH,CRITICAL juiceshop
        '''
      }
    }
  }
}
