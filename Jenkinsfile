pipeline {
    agent any
    
    stages {
        stage('Cloning') {
            steps {
                git branch: 'master', url: 'https://github.com/your/repository.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'flutter build apk --release'
            }
            
            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk'
                }
            }
        }
    }
}
