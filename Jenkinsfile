pipeline {
    agent any
    tools {
        maven 'Maven3'
    }
    environment {
        NEXUS_URL        = 'http://nexus:8081'
        NEXUS_DOCKER_REG = 'nexus:8083'
        IMAGE_NAME       = 'student-management'
        IMAGE_TAG        = "${BUILD_NUMBER}"
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
        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build(
                        "${NEXUS_DOCKER_REG}/${IMAGE_NAME}:${IMAGE_TAG}",
                        "."
                    )
                }
            }
        }
        stage('Docker Push to Nexus') {
            steps {
                script {
                    docker.withRegistry(
                        "http://${NEXUS_DOCKER_REG}",
                        'nexus-docker-credentials'
                    ) {
                        dockerImage.push("${IMAGE_TAG}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Cleanup Local Image') {
            steps {
                sh """
                    docker rmi ${NEXUS_DOCKER_REG}/${IMAGE_NAME}:${IMAGE_TAG} || true
                    docker rmi ${NEXUS_DOCKER_REG}/${IMAGE_NAME}:latest || true
                """
            }
        }
    }
    post {
        success {
            echo "✅ Pipeline SUCCESS — Image pushed: ${NEXUS_DOCKER_REG}/${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline FAILED on branch: ${env.BRANCH_NAME}"
        }
    }
}
