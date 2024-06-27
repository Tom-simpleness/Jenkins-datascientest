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
                        rm -Rf .kube
                        mkdir .kube
                        ls
                        cat $KUBECONFIG > .kube/config

                        # Check if the release exists
                        if helm status my-release --namespace dev >/dev/null 2>&1; then
                            # Release exists, perform an upgrade
                            helm upgrade --force --install my-release ./microservices --namespace dev --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        else
                            # Release does not exist, perform an installation
                            helm install my-release ./microservices --namespace dev --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        fi
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
