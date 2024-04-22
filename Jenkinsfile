pipeline {
    agent {
        label 'jumpserver'
    }

    environment {
        KUBECONFIG_CREDENTIAL_ID = 'k8s-kubeconfig-dev'
        version = "Springboot_${env.BUILD_NUMBER}"
        docker_image = "vigneshv04/springboot-app:${version}"
    }

    stages {
       stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/vignesha04/SpringBoot-APP.git'
            }
        }

       stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo \"$DOCKER_PASSWORD\" | sudo docker login --username \"$DOCKER_USERNAME\" --password-stdin"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "cd scripts/ && mvn clean package"
                    sh "sudo docker build -t 'vigneshv04/springboot-app:${version}' ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "sudo docker push 'vigneshv04/springboot-app:${version}'"
                }
            }
        }
        stage('Cleanup Docker Images') {
            steps {
                script {
                    sh "sudo docker rmi -f ${env.docker_image}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {

                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIAL_ID, variable: 'KUBECONFIG')]) {
                    script {
                      def kubeconfigPath = env.KUBECONFIG
                      withEnv(["VERSION=${env.version}"])
                      {
                         sh "echo ${VERSION}"
                         sh "export KUBECONFIG=${kubeconfigPath}"
                         //sh "kubectl scale deploy frontend --replicas=0 -n three-tier"
                         sh" sed -i 's/VERSION/${VERSION}/g' deploymentservice.yml"
                         sh "kubectl apply -f deploymentservice.yml --validate=false"
                         s
                      }
                    }
                }
            }
        }
    }
}
