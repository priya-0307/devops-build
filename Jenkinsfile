pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        EC2_KEY = credentials('ec2-key')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                ansiColor('xterm') {
                    sh './build.sh'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                ansiColor('xterm') {
                    sh './deploy.sh'
                }
            }
        }
    }

    post {
        success {
            echo "Build and deployment successful!"
        }
        failure {
            echo " Build failed. Check logs."
        }
    }
}
