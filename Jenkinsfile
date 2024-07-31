pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        docker build -t juice-shop .
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
        echo 'Testing...'
        snykSecurity(
          snykInstallation: 'SnykImageScanning',
          snykTokenId: 'organization-snyk-api-token'
        )
      }
    }
  }
}
