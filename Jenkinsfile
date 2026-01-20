pipeline {
    agent any

    tools {
        jdk 'Java 21'       // Make sure this matches the JDK name in Jenkins
        maven 'Maven 3.9.0' // Make sure this matches the Maven name in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout from your GitHub repo using credentials
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[
                              url: 'https://github.com/Guna-CG/Petclinic.git',
                              credentialsId: 'github-token' // Replace with your GitHub token ID
                          ]]
                ])
            }
        }

        stage('Build') {
            steps {
                script {
                    echo "Building the project with Maven..."
                    bat 'mvn clean package'
                }
            }
        }

        stage('Run Spring Boot') {
            steps {
                script {
                    echo "Starting Spring Boot on port 8081..."
                    bat 'start cmd /c "mvn spring-boot:run -Dserver.port=8081"'
                    echo "Spring Boot should now be running."
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        failure {
            echo "Build failed! Check the logs."
        }
    }
}
