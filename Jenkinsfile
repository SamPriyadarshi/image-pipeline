pipeline {
    agent any 
    GOOGLE_APPLICATION_CREDENTIALS = credentials('GCP_CREDENTIAL')

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

