

import boto3
import json

ses_client = boto3.client('ses', region_name='us-east-1')
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    # Extract information about the non-compliant resource from the event
    instance_id = event['detail']['instance-id']
    instance = ec2.Instance(instance_id)
    
    # Check if the 'Name' tag exists and has a value
    if not instance.tags or not any(tag['Key'] == 'Name' and tag['Value'] for tag in instance.tags):
        # Terminate the instance
        instance.terminate()
        print(f"Terminating instance {instance_id} for not having a 'Name' tag")
        
        # Customize the email message
        subject = f"Non-compliant resource detected: EC2 Instance - {instance_id}"
        message = f"Hello,\n\nA non-compliant EC2 instance was detected:\n\nInstance ID: {instance_id}\nViolation Reason: Missing 'Name' tag\n\nPlease take appropriate action to address this issue."

        # Send email notification using Amazon SES
        response = ses_client.send_email(
            Source='Williamsebenezer437@gmail.com',  # Replace with your email address
            Destination={
                'ToAddresses': ['Cikaylanre@gmail.com', 'macaulaytopsy@gmail.com', 'cwdederils@gmail.com']  # Replace with recipient email addresses
            },
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': message}}
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps('Email notification sent successfully')
        }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps('Instance is compliant')
        }
