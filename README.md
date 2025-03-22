# Fake Shop


## Variável de Ambiente
DB_HOST	=> Host do banco de dados PostgreSQL.

DB_USER => Nome do usuário do banco de dados PostgreSQL.

DB_PASSWORD	=> Senha do usuário do banco de dados PostgreSQL.

DB_NAME	=>	Nome do banco de dados PostgreSQL.

DB_PORT	=>	Porta de conexão com o banco de dados PostgreSQL.
----------------------------------------------------------------

--> Instruções do funcionamento da Pipeline CI - CD <--

"name: CI-CD

on:                           
    push:
        branches: ["main"]
    workflow_dispatch: "

--> Identifica o nome da Pipeline e define as "triggers" em que é acionada, sendo "push" para cada commit e "workflow_dispatch" para executar manualmente.
---

"jobs:
    CI:
        runs-on: ubuntu-latest
        steps: 
            - name: Obtendo o Codigo
              uses: actions/checkout@v4.2.2
            
            - name: Fazer login no Docker Hub
              uses: docker/login-action@v3
              with:
                username: ${{ secrets.DOCKERHUB_USERNAME }}   
                password: ${{ secrets.DOCKERHUB_TOKEN }}                                                                 
            
            - name: Build e push da imagem docker
              uses: docker/build-push-action@v6
              with:
                context: ./src                        
                push: true
                file: ./src/Dockerfile
                tags: |
                  pedroangelovargas/cluster-k8s:v${{ github.run_number }}
                  pedroangelovargas/cluster-k8s"


-->  O Primeiro "job" é referente a integração contínua (CI).Esse primeiro "step" do CI, faz o checkout do código no repositorio, o segundo realiza o login no Docker Hub através das credencias inseridas pelo usuário na sessão "secrets" do github, e o último faz a construção da imagem docker e o upload da mesma no Docker Hub.
---

"CD:
        needs: [CI]
        runs-on: ubuntu-latest
        steps:
            - name: Obtendo o Codigo
              uses: actions/checkout@v4.2.2
            
            - name: Criando Kubeconfig
              uses: azure/k8s-set-context@v4
              with: 
                method: kubeconfig
                kubeconfig: ${{ secrets.K8S_KUBECONFIG }}

            - name: Deploy do Manifesto
              uses: azure/k8s-deploy@v5
              with:
                manifests: k8s/ManifestoK8s.yml
                images: pedroangelovargas/cluster-k8s:v${{ github.run_number }}"

--> O segundo "job" é referente a entrega contínua (CD). Esse primeiro "step" do CD, faz o mesmo checkout do código, o segundo realiza a implantação do kubeconfig do cluster kubernetes on service e o último realiza o deploy do Manifesto Kubernetes.
---








