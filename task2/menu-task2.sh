#!/bin/bash
##### Environmets  ###
Project=$(gcloud config get-value project)
VM_Name="myjenkisvm"
Location="us-central1-c"
Firewall_Rule_Name="rule-allow-tcp-8080"
########

PS3='Follow these steps: '
steps=("Create Jenkins VM" "How to play Ansible" "ConfigJenkins" "Destroy VM" "Quit")
select step in "${steps[@]}"; do
    case $step in
        "Create Jenkins VM")
            echo "These command will create a CentOS VM , a firewall rule for port 8080"
            gcloud compute instances create $VM_Name \
            --zone=$Location  --machine-type=e2-small \
            --image-project=centos-cloud --image-family=centos-7 \
            --boot-disk-type=pd-standard --boot-disk-size=80GB

            gcloud compute firewall-rules create $Firewall_Rule_Name \
            --source-ranges 0.0.0.0/0 --target-tags allow-tcp-8080 --allow tcp:8080

            gcloud compute instances add-tags $VM_Name --tags allow-tcp-8080 --zone $Location
            break
            ;;
        "How to play Ansible")
            echo "Follow the README.md instructions:"
            echo "Enter by ssh to the JenkinsVM : gcloud beta compute ssh --zone us-central1-c $VM_Name --project $Project"
	        break
            ;;
        "ConfigJenkins")
            echo "Follow the README.md instructions"
	        break
            ;;
        "Destroy VM")
            echo "DEstroying the Jenkins VM and firewall rule"
            gcloud compute instances stop $VM_Name
            gcloud compute instances delete $VM_Name --zone=$Location --quiet
            gcloud compute firewall-rules delete $Firewall_Rule_Name --quiet
	        break
            ;;
	"Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done