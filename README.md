 Workflow / Architecture

1) Developer pushes code changes to GitHub (devops-build repository).

2) Jenkins (connected via webhook) automatically triggers the build pipeline.

3) Jenkins builds a Docker image using build.sh and pushes it to DockerHub.

4) AWS EC2 instance pulls the latest image and runs the application container.

5) Monitoring system (Prometheus, Alertmanager) checks the app’s uptime and sends alerts if it goes down.


 Project Flow

--> Fork and clone the repo:

--> git clone https://github.com/<your-username>/devops-build.git
--> cd devops-build


--> Build and run the application using Docker:

       # docker build -t my-react-app .
       # docker run -d -p 80:80 my-react-app


--> Create two bash scripts and make them executable:

       # chmod +x build.sh deploy.sh


--> Push updates to GitHub to trigger Jenkins CI/CD pipeline.

--> Jenkins CI/CD Pipeline Setup
      # Jenkins Installation

      # Jenkins installed on AWS EC2 (Ubuntu) instance.

--> Plugins installed:

    # Git

    # Docker Pipeline

    # Pipeline: Stage View

    # Node and NPM Plugin

    #  Jenkins Pipeline Configuration

--> Created a pipeline project connected to the devops-build GitHub repo.

--> Configured webhooks for automatic build triggers when code is pushed.

--> Pipeline Stages

--> Checkout → Pull code from GitHub

--> Build → Execute build.sh to build the Docker image

--> Push to DockerHub → Push image to DockerHub (dev or prod repo)

--> Deploy → Execute deploy.sh to deploy the app on EC2

--> Branch Logic

  # If code pushed to dev branch → build and push to Dev DockerHub repo

  # If merged to main/master → build and push to Prod DockerHub repo

--> Docker Configuration
     # Dockerfile
     # Docker compose.yaml



--> AWS EC2 Deployment
     Steps:

           # Launched t2.micro EC2 instance (Ubuntu)

           # Installed Docker and Node.js

          # Configured Security Group (SG):

                           Port	Purpose	Source
                              22	SSH	My IP
                              80	Application Access	0.0.0.0/0
                              8080	Jenkins	0.0.0.0/0

--> Pulled and ran the latest image:

  # docker pull <your-dockerhub-username>/my-react-app:latest
  # docker run -d -p 80:80 <your-dockerhub-username>/my-react-app:latest


Application accessible at:

        http://<EC2-Public-IP>

--> Monitoring System

      # Prometheus monitors app and instance metrics.

      # Node Exporter collects EC2-level metrics (CPU, memory, disk).

      # Alertmanager sends alerts when metrics cross thresholds (e.g., app down).


--> Screen shot for execution process.
      https://github.com/priya-0307/project-3-screenshot.git
