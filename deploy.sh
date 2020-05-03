#!/usr/bin/env bash

IMAGE_NAME="ubuntu-1604-xenial-v20200429" 
IMAGE_PROJECT="ubuntu-os-cloud"
VM_NAME="hive-discourse"
SIZE_GB="25"
DISK_TYPE="pd-ssd"
ZONE="us-east1-b"
REGION="us-east1"
NETWORK="discourse-network"
DISCOURSE_PATH="/home/discourse/"

# To get an IP address you can use this command.
# gcloud compute addresses create $ADDRESS_NAME \
#    --region $REGION
IP_ADDRESS="REPLACE-ME" 

# Let's install the Google SDK
curl https://sdk.cloud.google.com | bash

# Let's authenticate and update our configuration
gcloud init

# Firewall rules
gcloud compute firewall-rules create --network=$NETWORK \
        allow-ssh --allow=tcp:22 \


# Compute Engine Deployment
gcloud config set compute/zone $ZONE

gcloud compute instances create $VM_NAME \
    --image $IMAGE_NAME \
    --image-project $IMAGE_PROJECT \
    --create-disk size=$SIZE_GB,type=$DISK_TYPE \
    --network $NETWORK \
    --address $IP_ADDRESS

# Clone Discourse's repository.
gcloud compute ssh root@$VM_NAME \
    --zone $ZONE \ 
    --command "mkdir ${DISCOURSE_PATH} && cd ${DISCOURSE_PATH} && git clone https://github.com/discourse/discourse_docker"

# To continue with the setup, you must manually modify the /containers/ yml inside the instance.

