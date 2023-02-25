pipeline {
    agent any
    
    stages {
        stage('Cloning') {
            steps {
                git branch: 'master', url: 'https://github.com/Falchizao/scarlet-graph-client'
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
