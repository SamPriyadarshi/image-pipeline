pipeline {
    agent any 
    environment {
        //adding gcp credentials
        GOOGLE_APPLICATION_CREDENTIALS = credentials('svc-mando')
    
     }


    stages {
        stage('Checkout') {
            steps {
             checkout scm
            }
        }

          stage('Init') {
            steps {
            sh 'packer init ./packer/'
            }
        }

        stage('Validate Packer Template') {
            steps {
                // Validate the Packer template
                sh 'packer validate ./packer/' 
            }
        }

        stage('Build Image') {
            steps {
                // Build the image using Packer
                sh 'packer build ./packer/'
            }
        }
    }
}

