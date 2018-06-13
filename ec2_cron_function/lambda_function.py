import boto3
import paramiko

def lambda_handler(event, context):

    s3_client = boto3.client('s3')
    #Download private key file from secure S3 bucket
    s3_client.download_file('bucketname','awspem/xxxxxx.pem', '/tmp/xxxxx.pem')

    k = paramiko.RSAKey.from_private_key_file("/tmp/xxxxx.pem")
    c = paramiko.SSHClient()
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    host=event['IP']
    print "Connecting to " + host
    c.connect( hostname = host, username = "ubuntu", pkey = k )
    print "Connected to " + host

    commands = [
        "chmod 700 /home/ubuntu/scripts/cronjobs.sh",
        "/home/ubuntu/scripts/cronjobs.sh"
        ]
    for command in commands:
        print "Executing {}".format(command)
        stdin , stdout, stderr = c.exec_command(command)
        print stdout.read()
        print stderr.read()

    return
    {
        'message' : "Script execution completed. See Cloudwatch logs for complete output"
    }
