pipeline {
    agent any

    tools {
        jdk 'Java 21'
        maven 'Maven 3.9.0'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out repository...'
                git branch: 'main', url: 'https://github.com/Guna-CG/Petclinic.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project with Maven...'
                bat 'mvn clean package'
            }
        }

        stage('Run (Optional)') {
            steps {
                echo 'Starting the Spring Boot app on port 8081 in background...'
                // This will start the app in a new process without blocking Jenkins
                bat 'start java -jar target\\spring-petclinic-*.jar --server.port=8081'
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully! The jar is built and optionally running.'
        }
        failure {
            echo 'Pipeline failed. Check logs for errors.'
        }
    }
}
