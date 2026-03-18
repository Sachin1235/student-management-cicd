pipeline {
    agent any
    tools {
        maven 'Maven3'
    }
    environment {
        NEXUS_URL = 'http://localhost:8081'
    }
    stages {
        stage('Build') {
            steps {
                dir('app') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Publish to Nexus') {
            steps {
                dir('app') {
                    sh 'mvn deploy -s ~/.m2/settings.xml'
                }
            }
        }
    }
    post {
        success {
            echo "Pipeline SUCCESS on branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline FAILED on branch: ${env.BRANCH_NAME}"
        }
    }
}
