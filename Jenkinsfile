pipeline {
    agent any

    options {
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        MIX_ENV      = 'test'
        MIX_HOME     = "${WORKSPACE}/.mix"
        HEX_HOME     = "${WORKSPACE}/.hex"
        DB_CONTAINER = "pg-${BUILD_TAG}"
    }

    stages {
        stage('Banco de testes') {
            steps {
                sh '''
                    docker run -d --name "$DB_CONTAINER" \
                      -e POSTGRES_PASSWORD=postgres postgres:17
                    until docker exec "$DB_CONTAINER" pg_isready -U postgres; do sleep 1; done
                '''
            }
        }

        stage('CI') {
            agent {
                docker {
                    image 'elixir:1.18'
                    args "--link ${env.DB_CONTAINER}:db -e DB_HOST=db"
                    reuseNode true
                }
            }
            stages {
                stage('Dependências') {
                    steps {
                        sh 'mix local.hex --force && mix local.rebar --force'
                        sh 'mix deps.get'
                    }
                }
                stage('Compilação') {
                    steps { sh 'mix compile --warnings-as-errors' }
                }
                stage('Formatação') {
                    steps { sh 'mix format --check-formatted' }
                }
                stage('Credo') {
                    steps { sh 'mix credo' }
                }
                stage('Sobelow (SAST)') {
                    steps { sh 'cd apps/payments_hub_web && mix sobelow --exit medium' }
                }
                stage('mix_audit (SCA)') {
                    steps { sh 'mix deps.audit' }
                }
                stage('Testes') {
                    steps {
                        sh 'mix coveralls.html --umbrella'
                    }
                    post {
                        always {
                            junit allowEmptyResults: true, testResults: 'reports/junit/*.xml'
                            publishHTML(target: [
                                reportDir: 'cover',
                                reportFiles: 'excoveralls.html',
                                reportName: 'Cobertura',
                                keepAll: true,
                                alwaysLinkToLastBuild: true,
                                allowMissing: true
                            ])
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker rm -f "$DB_CONTAINER" || true'
        }
        success { echo 'Pipeline verde!' }
        failure { echo 'Pipeline quebrou. Veja o stage em vermelho.' }
    }
}