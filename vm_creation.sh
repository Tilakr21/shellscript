for instance in $@; do
        if [ $instance == nginx ]; then
            ip=$(aws ec2 run-instances \
                    --image-id ami-0220d79f3f480ecf5 \
                    --instance-type t3.small \
                    --security-group-ids sg-0039b9fd218e26beb \
                    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]'
                    --associate-public-ip-address \
                    --query "Instances[0].PublicIpAddress" \
                    --output text
                )
            aws route53 change-resource-record-sets \
                --hosted-zone-id $HOSTED_ZONE_ID \
                --change-batch '{
                    "Comment": "Updating record for ngginx",
                    "Changes": [
                    {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                        "Name": "'$instance'",
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
                  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]'
                  --associate-public-ip-address \
                  --query "Instances[0].PrivateIpAddress" \
                  --output text
                )
            aws route53 change-resource-record-sets \
                --hosted-zone-id $HOSTED_ZONE_ID \
                --change-batch '{
                    "Comment": "Updating record for ngginx",
                    "Changes": [
                    {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                        "Name": "'$instance'",
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