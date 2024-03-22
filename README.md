EC2 Tag Enforcement Lambda Function

**Overview**

This AWS Lambda function is designed to enforce tagging standards for EC2 instances. 
It terminates EC2 instances that are created without a specific tag ('Name' tag in this case)
and sends email notifications to specified recipients informing them of the non-compliant resource.

**Functionality**

	• Termination of Non-compliant Instances:
	• The Lambda function checks if EC2 instances are created without a 'Name' tag.
	• If an instance is found without the 'Name' tag, it is terminated to enforce tagging standards.
	• Email Notifications:
	• Email notifications are sent to specified recipients whenever a non-compliant EC2 instance is detected and terminated.
	• The email includes details about the non-compliant instance (instance ID) and the reason for termination (missing 'Name' tag).

**Configuration**

 **Permissions:**

	• Ensure that the Lambda function has the necessary permissions to:
	• Terminate EC2 instances.
	• Send emails using Amazon SES (Simple Email Service).
	• Access EC2 resources and AWS Config events.
	• Environment Variables:
	• No environment variables are required for this function.

**Usage**
Deployment:

	• Deploy the Lambda function to your AWS account using the AWS Management Console, 
 	AWS CLI, or an infrastructure-as-code tool like AWS CloudFormation.
	• Configure the Lambda function to be triggered by AWS Config Rules when non-compliant resources are detected.
	• Customization:
	• Customize the email sender address, recipient addresses, and message content in the Lambda function code as needed.
	• Modify the tagging standards and enforcement logic in the Lambda function code to suit your organization's requirements.

**Dependencies**

	• AWS SDK for Python (Boto3):
	• This Lambda function uses the Boto3 library to interact with AWS services such as EC2 and SES.
