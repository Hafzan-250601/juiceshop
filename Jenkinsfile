pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        docker pull bkimminich/juice-shop
        ls -a
        cd ..
        ls -a
        '''
      }
    }
  }
}
