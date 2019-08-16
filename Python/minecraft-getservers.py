import json, boto3

def lambda_handler(event, context):
    
    key = "KEY"
    statusCode = 500
    dynamodbTableName = "minecraft-proxy-servers"
    
    if key == event["queryStringParameters"]['key']:
        
        # Get servers in DynamoDB
        dynamodb = boto3.client('dynamodb')
        
        result = dynamodb.scan(TableName=dynamodbTableName)
        # Return status code for Success!
        statusCode = 200
        
    elif key != event["queryStringParameters"]['key']:
        # Wrong Key, Bugger Off!
        statusCode = 403

    return {
        'statusCode': statusCode,
        'body': json.dumps(result["Items"])
    }
