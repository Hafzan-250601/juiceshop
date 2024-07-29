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
        cd trivy
        AWS_REGION=ap-southeast-1 AWS_ACCOUNT_ID=921704920702 trivy image --format template --template "@contrib/asff.tpl" -o report.asff --no-progress --severity HIGH,CRITICAL bkimminich/juice-shop
        cat report.asff | jq \'.Findings\' > new_report.asff
        aws securityhub batch-import-findings --findings file://new_report.asff
        '''
      }
    }
  }
}
