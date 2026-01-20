pipeline {
    agent any

    tools {
        jdk 'Java 21'
    }

    environment {
        APP_PORT = "8081"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Guna-CG/Petclinic.git'
            }
        }

        stage('Build') {
            steps {
                bat '.\\mvnw.cmd clean package -DskipTests'
            }
        }

        stage('Run') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    bat ".\\mvnw.cmd spring-boot:run -Dserver.port=%APP_PORT%"
                }
            }
        }
    }
}
