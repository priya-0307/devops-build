pipeline {
  agent any

  environment {
    DOCKERHUB_USER = credentials('priyadharshini030722')   // Jenkins credential ID storing username
    DOCKERHUB_PASS = credentials('Viyan@030722')   // Jenkins credential ID storing password
    EC2_SSH_KEY = credentials('key-pair-1.pem')             // SSH private key credential (file)
    IMAGE = "${DOCKERHUB_USER}/devops-build"
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timestamps()
    ansiColor('xterm')
  }

  triggers {
    // optional: pollSCM('H/5 * * * *')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script { BRANCH = env.BRANCH_NAME ?: sh(returnStdout:true, script:'git rev-parse --abbrev-ref HEAD').trim() }
        echo "Branch: ${BRANCH}"
      }
    }

    stage('Install & Build') {
      agent { label 'docker' } // optional: run on node with docker
      steps {
        sh 'npm ci'
        sh 'npm run build'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          IMAGE_TAG = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
          sh "docker build -t ${IMAGE}:${IMAGE_TAG} ."
          sh "docker tag ${IMAGE}:${IMAGE_TAG} ${IMAGE}:latest"
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh "echo $DH_PASS | docker login -u $DH_USER --password-stdin"
          sh "docker push ${IMAGE}:${IMAGE_TAG}"
          sh "docker push ${IMAGE}:latest"
        }
      }
    }

    stage('Deploy to Prod') {
      when { branch 'main' }
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'PEM', usernameVariable: 'EC2_USER')]) {
          sh """
            scp -i $PEM -o StrictHostKeyChecking=no deploy.sh ec2-user@${params.EC2_HOST}:/tmp/deploy.sh
            ssh -i $PEM -o StrictHostKeyChecking=no ec2-user@${params.EC2_HOST} 'bash /tmp/deploy.sh'
          """
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline succeeded'
    }
    failure {
      mail to: 'team@example.com', subject: "Build failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}", body: "See Jenkins console"
    }
  }
}
