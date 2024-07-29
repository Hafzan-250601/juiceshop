pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''
        cd juiceshop
        docker build -t juiceshop .
        '''
      }
    stage('Scan image and upload findings to SecurityHub') {
      steps {
        sh '''
        cd trivy
        AWS_REGION=ap-southeast-1 AWS_ACCOUNT_ID=921704920702 trivy image --format template --template "@contrib/asff.tpl" -o report.asff --no-progress --severity HIGH,CRITICAL devopsapps
        cat report.asff | jq \'.Findings\'
        aws securityhub batch-import-findings --findings file://report.asff
        '''
      }
    }
    }
  }
}
