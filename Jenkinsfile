pipeline {
    agent any

    environment {
        WEBSITE_DIR = "${WORKSPACE}"
        TERRAFORM_DIR = "${WORKSPACE}/terraform"
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    echo 'Preparing environment...'
                    bat 'if not exist website-content mkdir website-content'
                }
            }
        }

        stage('Checkout') {
            steps {
                script {
                    echo 'Cloning repository...'
                    try {
                        git branch: 'main',
                            url: 'https://github.com/awscloud-practice/static-fweb',
                            credentialsId: 'github_ID'
                        echo 'Clone completed.'
                    } catch (Exception e) {
                        echo "Clone failed: ${e.getMessage()}"
                        throw e
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    echo 'Initializing Terraform...'
                    dir(TERRAFORM_DIR) {
                        bat 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    echo 'Applying Terraform configuration...'
                    dir(TERRAFORM_DIR) {
                        bat 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Deploy Files') {
            steps {
                script {
                    echo 'Deploying files to IIS...'
                    bat "xcopy /s /y \"${WEBSITE_DIR}\\*\" C:\\inetpub\\wwwroot\\DuplicateSite\\"
                }
            }
        }
    }
}
