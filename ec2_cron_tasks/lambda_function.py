
import boto3


def trigger_handler(event, context):
    #Get IP addresses of EC2 instances
    client = boto3.client('ec2')
    instDict=client.describe_instances(
            Filters=[{'Name':'tag:Name','Values':['myec2cronjob']}]
        )
    hostList=[]
    for r in instDict['Reservations']:
        for inst in r['Instances']:
            hostList.append(inst['PublicIpAddress'])
    #Invoke worker function for each IP address
    client = boto3.client('lambda')
    for host in hostList:
        print "Invoking ec2_cron_function on " + host
        invokeResponse=client.invoke(
            FunctionName='ec2_cron_function',
            InvocationType='Event',
            LogType='Tail',
            Payload='{"IP":"'+ host +'"}'
        )
    return{
        'message' : "ec2 cron task started"
    }
