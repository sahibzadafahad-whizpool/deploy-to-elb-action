#!/bin/sh -l

# Save the SSH file to a temporary location so that it can be used later

echo "$3" > /tmp/writeup.pem
chmod 0600 /tmp/writeup.pem

# Describe the Autoscaling group and deploy to all of the servers in the group

INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $2 | jq --raw-output '.AutoScalingGroups[0].Instances | map(.InstanceId) | join(";")')
export IFS=";"
for instance_id in $INSTANCE_IDS; do \
    INSTANCE_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $instance_id | jq --raw-output '.Reservations[0].Instances[0].PublicIpAddress'); \
    echo "Deploying to $INSTANCE_IP_ADDRESS..."; \
    ssh centos@"$INSTANCE_IP_ADDRESS" -i /tmp/writeup.pem
    #ssh -oStrictHostKeyChecking=no -i /tmp/writeup.pem centos@"$INSTANCE_IP_ADDRESS" $1; \
done
