#!/bin/bash
##### Environmets  ###
Project=$(gcloud config get-value project)
VM_Name="myjenkisvm"
Location="us-central1-c"
Firewall_Rule_Jenkins="rule-allow-tcp-8080"
Firewall_Rule_Jssh="rule-allow-ssh"
########

PS3='Follow these steps: '
steps=("Create Jenkins VM" "Connect to ssh to VM" "Install and Config Jenkins" "Destroy VM" "Quit")
select step in "${steps[@]}"; do
    case $step in
        "Create Jenkins VM")
            echo "These command will create a CentOS VM , a firewall rule for port 8080"
            gcloud compute instances create $VM_Name \
            --zone=$Location  --machine-type=e2-small \
            --image-project=centos-cloud --image-family=centos-7 \
            --boot-disk-type=pd-standard --boot-disk-size=80GB \
            --quiet

            gcloud compute firewall-rules create $Firewall_Rule_Jenkins \
            --source-ranges 0.0.0.0/0 --target-tags allow-tcp-8080 --allow tcp:8080

            gcloud compute instances add-tags $VM_Name --tags allow-tcp-8080 --zone $Location

            gcloud compute scp linux_jenkins.yml  $VM_Name:/tmp
            gcloud compute scp ansible-install-script.sh  $VM_Name:/tmp

            sleep 3

            echo "Jenkins VM created"
            gcloud compute instances list

            break
            ;;
        "Connect to ssh to VM")
            echo "Follow the README.md instructions:"
            echo "Enter by ssh to the JenkinsVM :"
            echo "gcloud beta compute ssh --zone \"us-central1-c\" \"$VM_Name\" --project \"$Project\""
	        break
            ;;
        "Install and Config Jenkins")
            echo "Follow the section 2.4 Installing Jenkins using Ansible"
	        break
            ;;
        "Destroy VM")
            echo "DEstroying the Jenkins VM and firewall rule"
            gcloud compute instances stop $VM_Name
            gcloud compute instances delete $VM_Name --zone=$Location --quiet
            gcloud compute firewall-rules delete $Firewall_Rule_Name --quiet
            echo "***** VM and firewall rule deleted !! *****"
	        break
            ;;
	"Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done