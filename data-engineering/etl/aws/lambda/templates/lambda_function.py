import boto3
import snowflake.connector
import json

def lambda_handler(event, context):
    # Extract file details from S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    # Snowflake connection
    conn = snowflake.connector.connect(
        user='YOUR_USER',
        password='YOUR_PASSWORD',
        account='YOUR_ACCOUNT',
        warehouse='YOUR_WAREHOUSE',
        database='YOUR_DATABASE',
        schema='YOUR_SCHEMA'
    )
    cur = conn.cursor()

    # Load file into Snowflake
    sql = f"""
    COPY INTO your_table
    FROM 's3://{bucket_name}/{file_key}'
    CREDENTIALS=(AWS_KEY_ID='YOUR_AWS_KEY' AWS_SECRET_KEY='YOUR_AWS_SECRET')
    FILE_FORMAT=(TYPE=CSV SKIP_HEADER=1);
    """
    cur.execute(sql)
    conn.commit()

    return {
        'statusCode': 200,
        'body': json.dumps('File loaded into Snowflake successfully!')
    }

