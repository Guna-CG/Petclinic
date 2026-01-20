pipeline {
    agent any

    tools {
        jdk 'Java 21'
        maven 'Maven 3.9.0'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Guna-CG/Petclinic.git'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Run') {
            steps {
                // Runs the Spring Boot app on port 8081
                bat 'mvn spring-boot:run -Dserver.port=8081'
            }
        }
    }
}
