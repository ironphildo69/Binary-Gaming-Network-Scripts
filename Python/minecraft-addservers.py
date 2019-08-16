import json, boto3
# This Python Script runs via Lambda and API Gateway to update a DynamoDB table with the list of servers via a querystring.
# This is used to update a proxy later with servers dynamically.

def lambda_handler(event, context):
    
    key = "KEY"
    statusCode = 500
    dynamodbTableName = "minecraft-proxy-servers"
    instancename = 'test'
    
    if key == event["queryStringParameters"]['key']:
        
        # Get EC2 Server Name
        
        ec2client = boto3.client('ec2')
        
        response = ec2client.describe_instances(Filters=[{'Name' : 'ip-address','Values' : [event["queryStringParameters"]['ip']]}])

        #print(response['Reservations'][0]['Instances'][0]['Tags'][0]['Value'])

        # Put server in DynamoDB
        dynamodb = boto3.client('dynamodb')
        
        dynamodb.put_item(TableName=dynamodbTableName, Item={'ServerId':{'S':response['Reservations'][0]['Instances'][0]['Tags'][0]['Value'] + " = " + event["queryStringParameters"]['ip']}})
        
        # Return status code for Success!
        statusCode = 200
        
    elif key != event["queryStringParameters"]['key']:
        # Wrong Key, Bugger Off!
        statusCode = 403

    return {
        'statusCode': statusCode,
        'body': json.dumps(statusCode)
        #'body': json.dumps(response['Reservations']['Instances'])
    }
