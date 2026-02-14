#!/bin/bash
for instance in $@; do
    HOSTED_ZONE_ID=Z048988723HS7J4W6I2HO
        if [ $instance == frontend ]; then
            instance_id=$(aws ec2 run-instances \
                    --image-id ami-0220d79f3f480ecf5 \
                    --instance-type t3.small \
                    --security-group-ids sg-0039b9fd218e26beb \
                    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$instance'}]'\
                    --query "Instances[0].InstanceId" \
                    --output text
                )
            aws ec2 wait instance-running --instance-ids $instance_id
            ip=$(aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query "Reservations[0].Instances[0].PublicIpAddress" \
            --output text)
            echo "Instance Public IP: $ip"
            aws route53 change-resource-record-sets \
                --hosted-zone-id $HOSTED_ZONE_ID \
                --change-batch '{
                    "Comment": "Updating record for ngginx",
                    "Changes": [
                    {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                        "Name": "'$instance'.tilakrepalle.in",
                        "Type": "A",
                        "TTL": '1',
                        "ResourceRecords": [
                            {
                            "Value": "'$ip'"
                            }
                        ]
                        }
                    }
                    ]
                }'
        else
            ip=$(aws ec2 run-instances \
                  --image-id ami-0220d79f3f480ecf5 \
                  --instance-type t3.small \
                  --security-group-ids sg-0039b9fd218e26beb \
                  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$instance'}]'\
                  --query "Instances[0].PrivateIpAddress" \
                  --output text
                )
            echo "Instance Private IP: $ip"
            aws route53 change-resource-record-sets \
                --hosted-zone-id $HOSTED_ZONE_ID \
                --change-batch '{
                    "Comment": "Updating record for ngginx",
                    "Changes": [
                    {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                        "Name": "'$instance'.tilakrepalle.in",
                        "Type": "A",
                        "TTL": '1',
                        "ResourceRecords": [
                            {
                            "Value": "'$ip'"
                            }
                        ]
                        }
                    }
                    ]
                }'

        fi
done