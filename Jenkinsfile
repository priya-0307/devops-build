pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'priyadharshini030722'
    IMAGE_NAME = "${DOCKERHUB_USER}/devops-build"
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
          withCredentials([
            usernamePassword(
              credentialsId: 'dockerhub-creds',
              usernameVariable: 'DOCKER_USER',
              passwordVariable: 'DOCKER_PASS'
            )
          ]) {
            sh '''
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
