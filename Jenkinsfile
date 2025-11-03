
pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'priyadharshini030722'
    DEV_REPO = "${DOCKERHUB_USER}/devops-build-dev"
    PROD_REPO = "${DOCKERHUB_USER}/devops-build-prod"
    EC2_HOST = 'ubuntu@3.6.92.70'
    EC2_KEY = 'key-pair-1.pem' 
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/priya-0307/devops-build.git'
      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
            // Define the image name based on the branch
          def branch = env.BRANCH_NAME ?: 'dev'
          if (branch == 'main' || branch == 'prod') {
            env.IMAGE_NAME = "${DOCKERHUB_USER}/devops-build-prod"
          } else {
            env.IMAGE_NAME = "${DOCKERHUB_USER}/devops-build-dev"
          }
          withCredentials([
            usernamePassword(
              credentialsId: 'dockerhub-creds',
              usernameVariable: 'DOCKER_USER',
              passwordVariable: 'DOCKER_PASS'
            )
          ]) {
            sh '''
              cd $WORKSPACE   # make sure we're in repo root
              ls -al          # debug: confirm Dockerfile + package.json exist
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker build -t $IMAGE_NAME:latest .
              docker push $IMAGE_NAME:latest
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo '✅ Build and push successful!'
    }
    failure {
      echo '❌ Build failed!'
    }
  }
}
