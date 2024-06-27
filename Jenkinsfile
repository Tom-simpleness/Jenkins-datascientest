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
        stage('Deploy to dev-env') {
            steps {
                script {
                    sh '''
                        rm -Rf .kube
                        mkdir .kube
                        ls
                        cat $KUBECONFIG > .kube/config

                        # Check if the release exists
                        if helm status dev-env --namespace dev >/dev/null 2>&1; then
                            # Release exists, perform an upgrade
                            helm upgrade --install dev-env ./microservices --namespace dev --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        else
                            # Release does not exist, perform an installation
                            helm install dev-env ./microservices --namespace dev --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        fi
                    '''
                }
            }
        }
        stage('Deploy to qa-env') {
            steps {
                script {
                    sh '''
                        rm -Rf .kube
                        mkdir .kube
                        ls
                        cat $KUBECONFIG > .kube/config
                        echo "Current directory: $(pwd)"
                        echo "Contents of current directory:"
                        ls -la
                        echo "Contents of values-qa.yaml:"
                        cat values-qa.yaml
                        # Check if the release exists
                        if helm status qa-env --namespace qa >/dev/null 2>&1; then
                            # Release exists, perform an upgrade
                            helm upgrade --install qa-env ./microservices --namespace qa --values values-qa.yaml --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG} --force
                        else
                            # Release does not exist, perform an installation
                            helm install qa-env ./microservices --namespace qa --values values-qa.yaml --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG} 
                        fi
                    '''
                }
            }
        }
        stage('Deploy to staging-env') {
            steps {
                script {
                    sh '''
                        rm -Rf .kube
                        mkdir .kube
                        ls
                        cat $KUBECONFIG > .kube/config

                        # Check if the release exists
                        if helm status staging-env --namespace staging >/dev/null 2>&1; then
                            # Release exists, perform an upgrade
                            helm upgrade --install staging-env ./microservices --namespace staging --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        else
                            # Release does not exist, perform an installation
                            helm install staging-env ./microservices --namespace staging --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        fi
                    '''
                }
            }
        }
        stage('Deploy to production') {
            steps {
                script {
                    input message: 'Do you want to deploy to production?', ok: 'Deploy'
                    sh '''
                        rm -Rf .kube
                        mkdir .kube
                        ls
                        cat $KUBECONFIG > .kube/config

                        # Check if the release exists
                        if helm status production-env --namespace production >/dev/null 2>&1; then
                            # Release exists, perform an upgrade
                            helm upgrade --install production-env ./microservices --namespace prod --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
                        else
                            # Release does not exist, perform an installation
                            helm install production-env ./microservices --namespace prod --set castService.image.tag=${DOCKER_TAG},movieService.image.tag=${DOCKER_TAG}
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
