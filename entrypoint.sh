#!/bin/sh -l

echo "Saving SSH key to temporary directory"

echo $3 > /tmp/key_pair.pem
chmod 0600 /tmp/key_pair.pem

echo "Describing ASGs..."

cat /tmp/key_pair.pem

INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $2 | jq --raw-output '.AutoScalingGroups[0].Instances | map(.InstanceId) | join(";")')
export IFS=";"
for instance_id in $INSTANCE_IDS; do \
    INSTANCE_IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $instance_id | jq --raw-output '.Reservations[0].Instances[0].PublicIpAddress'); \
    echo "Deploying to $INSTANCE_IP_ADDRESS..."; \
    ssh -oStrictHostKeyChecking=no -i /tmp/key_pair.pem ubuntu@"$INSTANCE_IP_ADDRESS" $1; \
done