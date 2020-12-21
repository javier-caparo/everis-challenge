#!/bin/bash
# TASK1 Bash Menu Script Example

####### ENV VARIABLES ########
PROJECT_ID=$(gcloud config get-value project)
echo $PROJECT_ID
REGION_ID=$(gcloud config get-value compute/region)
echo $REGION_ID
LOCATION_ID=$(gcloud config get-value compute/zone)
echo $LOCATION_ID
##############################

PS3='Please enter your MENU choice: '
options=("Create tfvars file" "Create K8s" "Deploy REST API APP" "Destroy K8s" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create tfvars file")
            echo 'Creating terraform.tfvars file...'
            echo "project_id = \"$PROJECT_ID\"" > terraform.tfvars
            echo "region     = \"$REGION_ID\"" >> terraform.tfvars
            echo "location     = \"$LOCATION_ID\"" >> terraform.tfvars
            cat terraform.tfvars
            break;;
        "Create K8s")
            echo "you chose Create 8s"
            terraform init
            terraform apply -auto-approve
            break
            ;;
        "Deploy REST API APP")
            echo "Deploying Flask/Python Rest API APP in K8s cluster..."
            echo "gettign K8s cluster credentials..."
            gcloud container clusters get-credentials $PROJECT_ID-gke --region $REGION_ID
            echo "k8s location of the nodes..."
            gcloud container clusters describe $PROJECT_ID-gke --region $REGION_ID --format='default(locations)'
            echo "k8s nodes list..."
            gcloud compute instances list --filter $PROJECT_ID
            echo "nodes info..."
            kubectl get nodes
            echo "deploy / service/ ingress config creation..."
            kubectl create -f k8s-deploy.yaml
            kubectl create -f k8s-service.yaml
            kubectl create -f k8s-ingress.yaml
            echo "just wait a little bit.."
            sleep 10
            echo "get pods info..."
            kubectl get pods
            echo "get services info..."
            kubectl get services
            echo "get ingress controller info..."
            kubectl get ingress
            echo "You can try the app in some minutes, just wait the ingress get an address"
            add  
            break
            ;;
        "Destroy K8s")
            echo " Destroying K8s cluster with terraform"
            terraform destroy -auto-approve
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done