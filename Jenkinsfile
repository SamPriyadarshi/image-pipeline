pipeline {
    agent any 

    stages {
        stage('Checkout') {
            steps {
                // Checkout your project code from Git
                git branch: 'main', 
                    credentialsId: 'your-github-credentials-id', 
                    url: 'https://github.com/your-username/your-repo.git' 
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
