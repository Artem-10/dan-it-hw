import boto3

REGION = 'eu-central-1'
TAG_KEY = 'Auto-Stop'
TAG_VALUE = 'true'

def lambda_handler(event, context):
    print (f"function is started, looking for instance with tegs {TAG_KEY}:{TAG_VALUE} on region {REGION}")

    ec2 = boto3.client('ec2', region_name=REGION)



    filters = [
        {'Name': 'instance-state-name', 'Values': ['running']},
        {'Name': 'tag:' + TAG_KEY, 'Values': [TAG_VALUE]}
    ]

    response = ec2.describe_instances(Filters=filters)

    instances_to_stop = []

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances_to_stop.append(instance['InstanceId'])

    if not instances_to_stop:
        messege = "not found launched instances with tag for stop"
        print(messege)
        return {'statusCode': 200, 'body': messege}

    print(f"found next instances for stop: {', '.join(instances_to_stop)}")

    ec2.stop_instances(InstanceIds=instances_to_stop)

    messege = f"comand for stoping successfully sent for instances"
    print(messege)

    return {'statusCode': 200, 'body': messege}
