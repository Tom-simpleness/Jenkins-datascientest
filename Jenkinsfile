pipeline {
    environment {
        // DockerHub credentials
        DOCKER_ID = "dockerstudi"
        DOCKER_IMAGE_CAST = "dts-exam-cast"
        DOCKER_IMAGE_MOVIE = "dts-exam-movie"
        DOCKER_TAG = "v.${BUILD_ID}.0" // Tagging images with the current build ID
        DOCKER_PASS = credentials("DOCKER_HUB_PASS") // DockerHub password from Jenkins credentials

        // Kubernetes credentials
        KUBECONFIG = credentials("config") // kubeconfig file from Jenkins credentials
    }
    agent any
    stages {
        stage('Docker Build Image') {
            parallel {
                stage('Build Cast Service') {
                    steps {
                        script {
                            sh '''
                                docker build -t $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG ./cast-service
                            '''
                        }
                    }
                }
                stage('Build Movie Service') {
                    steps {
                        script {
                            sh '''
                                docker build -t $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG ./movie-service
                            '''
                        }
                    }
                }
            }
        }
        stage('Docker Push DockerHub') {
            parallel {
                stage('Push Cast Service') {
                    steps {
                        script {
                            sh '''
                                docker login -u $DOCKER_ID -p $DOCKER_PASS
                                docker push $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG
                            '''
                        }
                    }
                }
                stage('Push Movie Service') {
                    steps {
                        script {
                            sh '''
                                docker login -u $DOCKER_ID -p $DOCKER_PASS
                                docker push $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
                            '''
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        sudo rm -Rf .kube
                        sudo mkdir .kube
                        ls
                        sudo cat $KUBECONFIG > .kube/config

                        # Deploy Helm chart
                        helm upgrade --install jenkins-datascientest ./docker-compose --namespace dev --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
