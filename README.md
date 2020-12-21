# everis-challenge

## Challenges (Task) descriptions

### task 1

> Crear un script bash o makefile, que acepte parámetros (CREATE, DESTROY y OUTPUT) con los siguientes pasos:
> - Exportar las variables necesarias para crear recursos en GCP (utilizar las credenciales previamente descargadas).
> - Utilizar terraform o pulumi para crear un Cluster de Kubernetes de un solo nodo (GKE).
> - Instalar ingress controller en el Cluster de k8s.
> - Crear una imagen docker para desplegar una aplicación tipo RESTFUL API, basada en python que responda a siguientes dos recursos:
> - /greetings: message —> “Hello World from $HOSTNAME”.
> - /square: message —>  number: X, square: Y, donde Y es el cuadrado de X. Se espera un response con el cuadrado.
> - Subir la imagen el registry propio del proyecto gcp ej: gcr.io/$MYPROJECT/mypythonapp.
> - Desplegar la imagen con los objetos mínimos necesarios (no utilizar pods ni replicasets directamente).
> - El servicio debe poder ser consumido públicamente.
> - NOTA: variabilizar todos los campos que lo ameritan, por ejemplo el PROJECT, para que el script pueda ser ejecutado por otra persona con otra cuenta GCP

### Task 2
> - Crear un script bash o makefile, con los siguientes pasos:
> - Exportar las variables necesarias para crear recursos en GCP (utilizar las credenciales previamente descargadas).
> - Crear una VM basada en Centos
> - Instalar Jenkins en la VM (Puede ser Instalado con Docker o como Servicio, pero es importante que la instalación se realice a través de un playbook de ansible)
> - Instalar plugins estándar de pipeline,
> - Crear un sharedlib que pueda compilar maven.
> - Crear un Job que haga uso del sharedlib para compilar exitosamente un proyecto java simple tipo “Hello World”
> - El repositorio para la aplicación de Java debe ser publico.
> - Nota: Todo debe realizarse de manera automática y que sea idempotente, para que cualquier persona pueda alcanzar el mismo resultado con sus propia cuentas, projects y credenciales. En el uso de ansible se penalizara para la evaluación la no utilización de los módulos especializados y por su sustitución de modelos genéricos como shell y command.


## Prerequites
- To get a GCP Account ( free preferibly)
- To create a new GCP Project containing a new service account and public SSH key. 
- Enable the APIS for Container Registry and Kubernetes on that project


- To install [Google Cloud SDK]  to use glcoud CLI tool on the machine/laptop/desktop/vm where you are goign to perform the configurations
- To install [terraform CLI](https://www.terraform.io/downloads.html)  on your machine



## TASK 1 - STEPS to resolve the challenge

1.0 Authenticate with gcloud using the Service Account created. Example
```sh
gcloud auth activate-service-account everis@challenge-everis-299103.iam.gserviceaccount.com --key-file=challenge-everis-299103-415131ccc2f2.json
```

1.1 Build a flask/python restful api . 
- You can download the source files  from this [GitHub repo](https://github.com/jfcb853/everis-challenge-task1api.git)

- Build the docker image
```sh
docker build -t task1api .
```
- get the name of the GCP Project and tagged the image
```sh  
gcloud config get-value project
docker tag task1api gcr.io/challenge-everis-299103/task1api
docker images
```

- Push the image  to GCP Container Registry
```sh
gcloud auth configure-docker
docker push gcr.io/challenge-everis-299103/task1api
gcloud container images list
```

1.2 Execute this script to create the GKE cluster , deploy the APP
```sh
cd task1
./menu-task1.sh
```
Follow this order:
- Execute option 1 to generate the "terraform.tfvas" file

- Exeucte option 2 to create the GKE cluster

- Execute the option 3 to deploy the REST API App to GKE Cluster ( using deploy/service/ingress config)


IMPORTANT NOTES: 
> BE PATIENT ( GKE cluster takes aprox 10 minutes, and ingress service also takes aprox 6 minutes to be up
> Check the IP Address of the ingress , cause this will be the Public IP of the APP ( be patient ). Cgeck the images subdirectory to see some examples. Then you ga hot : http://<ingress ipaddress></ingress>

Example:
```sh
kubectl get ingress

NAME            HOSTS   ADDRESS          PORTS   AGE
task1-ingress   *       34.120.169.215   80      31m
```
Som examples to test the Restful api
```html
http://34.120.169.215/greetings
http://34.120.169.215/square/?x=2
```

1.3 To destroy the K8s cluster
- Execute the Option 4 fo the menu " Destroy K8s"
```sh
pwd
./menu-task1.sh
  --> Choose Option 4
```
Notes: be patient, GKE cluster will be destroyed

==========================

## TASK 2 - STEPS to resolve the challenge

2.1 Login to gcloud service account


2.2. Execute the step 1 of the menu to create a Centos VM and firewall rule to open port 8080  
```sh
pwd
cd task2
./menu-task2.sh
  --> Option 1
```


2.3. Copy files remotely to that new VM

gcloud compute scp ~/linux_jenkins.yml  example-instance:~/

2.3. Connect by ssh to your new VM instance using the command showed on Option 2 of the Menu;
```sh
./menu-task2.sh
   --> Option 2

Example:
gcloud beta compute ssh --zone us-central1-c myjenkisvm --project challenge-everis-299103
```

2.4 On that VM create a file: `"linux_jenkins.yml"` and paste the content of this file 



==========================

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

    [gcloud CLI tool]: <https://cloud.google.com/sdk/docs/install>

    [Plapi]: <>