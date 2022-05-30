# bigdata-k8s

Esse repositório tem como propósito criar um ambiente big data do zero no Kubernetes. As ferramentas utilizadas nesse projeto são:

- Minio (Data Lake)
- Airflow (Orquestrador)
- Apache Kafka (Streaming)
- Apache Spark on K8S (Processamento Batch e Streaming)
- JupyterHub (Processamento - Integrado com Apache Spark)
- Delta (Delta Lake integrado com o Apache Spark e Jupyterhub)
- Trino (Virtualizacão de dados - Camada SQL)
- Superset (Data Viz)

Arquitetura do projeto:
![architeture](https://user-images.githubusercontent.com/40548889/170894059-884e771f-3970-427e-a2a2-47f726d8fe8f.png)

Todo esse ambiente foi criado em um cluster Kubernetes local na minha máquina pessoal utilizando o K3D, que utiliza o Docker para simular um cluster Kubernetes multi-node rodando em containers. Porém, todos os manifestos e helm charts criados nesse repositório podem ser utilizados em servicos gerenciados de Kubernetes de Cloud Providers (EKS, GKE, AKS), os únicos pré-requisitos seriam os seguintes:
- [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) configurado
- [Storage Class](https://kubernetes.io/docs/concepts/storage/storage-classes/) configurado

Nesse tutorial, todo o ambiente será criado utilizando o K3D para rodar em uma máquina local.

Pré-Requisitos:
- [Docker](https://www.docker.com/products/docker-desktop/) (No meu caso, o meu PC é um mac, mas você pode baixar a versão correspondente do seu Sistema Operacional)

OBS: o ambiente pode ser um pouco pesado, então em alguns casos será necessário mudar os valores de memória default dos manifests/helm charts.

Após a instalacão do Docker, teremos o necessário para configurar nosso ambiente big data, então bora para o tutorial!

---
# K3D
Para instalar o K3D, execute um dos comandos abaixo:
-  `wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash`
-  `curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash`

Após instalado, já podemos criar um cluster. Para criar um cluster Kubernetes usando o K3D, execute o seguinte comando:
```
k3d cluster create --agents 3 -p '80:30000'
```
Ele criará um cluster Kubernetes com 1 master e 3 worker nodes. Lembrando que você pode colocar a qualquer quantidade de worker nodes, mas nesse tutorial, vamos seguir com 3.

Quando o K3D é instalado ele automaticamente instala o `kubectl` junto, então após o comando de criacão do cluster, você pode confirmar se tudo aconteceu conforme o esperado executando o seguinte comando:
```
kubectl get nodes
```

OBS: Esse Bind da porta 80 para a 30000 do cluster Kubernetes criado no Docker será explicado no próximo tópico.

---
# Ingress Controller
O Ingress Controller é um componente que permite o acesso externo a pods que estão executando dentro do Kubernetes. Em outras palavras, o Ingress Controller será nossa porta de acesso ao cluster.
Mas espera aí, é possível utilizá-lo em um ambiente rodando em uma máquina local?

Sim, é possível! Não é um método muito "elegante", mas é muito útil para o dia a dia. O mais interessante é que tudo que for aplicado nesse ambiente local, seria praticamente da mesma em um Cloud Provider. A única diferenca é que o Cloud Provider criaria um Load Balancer e Zonas DNS e aqui, nós utilizaremos o redirecionamento de porta do Docker e o arquivos Hosts da máquina local, mas a nível usuário e manisfestos, eles serão exatamente os mesmos.

Nesse tutorial, utilizaremos o Nginx como nosso Ingress Controller. Para criá-lo, a partir do diretório raiz do projeto, execute os seguintes comandos:
```
cd ingress-controller
kubectl apply -f ingress-controller.yaml
```
Dentro desse manifest, o Service do Nginx foi configurado como NodePort, tendo como bind a porta 30000 e aqui está a mágica de como tudo isso vai permitir acessos externos ao servicos do cluster.

No passo anterior, na criacao do cluster, definimos que toda requisicão feita na porta 80 da máquina local terá seu tráfego redirecionado para a porta 30000 do cluster Kubernetes que está executando dentro do Docker e agora, configuramos que o servico que está rodando nessa porta dentro do cluster Kubernetes será o Nginx, ou seja, o acesso externo terá o seguinte fluxo:



---
# Namespace
No intuito de organizar, todo esse projeto vai ser criado em uma namespace específica do Kubernetes chamada bigdata.
Para criá-la, execute o seguinte comando no diretório raiz do projeto:
```
bash create-namespace.sh
```

---
# Minio
O [Minio](https://min.io/) é um Object Storage nativo para Kubernetes. Ele será o nosso Data Lake, onde todos os dados serão armazenados. 
Ele possui dois métodos principais de instalacão:
- Helm Chart
- Operator

Nesse tutorial, instalaremos o Minio via Helm Chart.

Para instalá-lo, a partir do diretório raiz do projeto, execute os seguintes comandos:
```
cd minio
bash install-minio.sh
```
Esse script simplesmente faz o download do repositório do Helm do Minio e instala-o utilizando como paramêtro o arquivo values.yaml que está dentro do diretório. Nesse arquivo são definidas todas as propriedades que Minio vai possuir (memória, storage, quantidade de nodes). Os valores default podem não atender exatamente o seu caso de uso, então sinta-se livre para modificar esse arquivo conforme sua necessidade. 

### OBS: O values.yaml será utilizado para todas as ferramentas que forem instaladas via Helm, então sinta-se livre para modificar algumas configuracões desse arquivo de acordo com seu caso de uso para qualquer ferramenta que o utilizar


