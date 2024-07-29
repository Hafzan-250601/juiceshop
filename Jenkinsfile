pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        cd DevopsClassFront
        docker build -t juiceshop .
        '''
      }
    }
  }
}
