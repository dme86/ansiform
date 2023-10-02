#!/usr/bin/python


import boto3
import json


# Create S3 client
s3 = boto3.client('s3')


# Fetch list of S3 bucket names
response = s3.list_buckets()


# Create inventory dictionary
inventory = {
    '_meta': {
        'hostvars': {}
    },
    'all': {
        'hosts': []
    }
}


# Fetch tags for each bucket; include them in the inventory
for bucket in response['Buckets']:
    bucket_name = bucket['Name']
    inventory['all']['hosts'].append(bucket_name)
    inventory['_meta']['hostvars'][bucket_name] = {
        'tags': {}
    }


    # Fetch tags for current bucket
    tags_response = s3.get_bucket_tagging(Bucket=bucket_name)
    if 'TagSet' in tags_response:
        for tag in tags_response['TagSet']:
            inventory['_meta']['hostvars'][bucket_name]['tags'][tag['Key']] = tag['Value']


# Output inventory in JSON format
print(json.dumps(inventory))
