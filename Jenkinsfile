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
              cd $WORKSPACE
              ls -al
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
              docker build -t $IMAGE_NAME:latest .
              docker push $IMAGE_NAME:latest
            '''
          }
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        script {
          sh '''
            echo " Deploying application to EC2 instance..."
            chmod 400 $EC2_KEY

            ssh -o StrictHostKeyChecking=no -i $EC2_KEY $EC2_HOST << 'EOF'
              echo "Pulling latest image from Docker Hub..."
              docker pull ${IMAGE_NAME}:latest
            EOF
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Build, push, and deploy successful!'
    }
    failure {
      echo 'Build or deploy failed!'
    }
  }
}
