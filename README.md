# ssh-ec2-AWS-Lambda

If you don’t already have the AWS command line interface (CLI) you can install it with pip like so.
```shell
sudo pip install awscli
aws configure
# add aws id and assess key
```
Now we create a AWS CLI user. This user is our entry into AWS.

Create a user group 'lambda_group'
```shell
aws iam create-group --group-name lambda_group
```
Create a user 'lambda_user'
```shell
aws iam create-user --user-name lambda_user
```
Add our user to the group
```shell
aws iam add-user-to-group --user-name lambda_user --group-name lambda_group
```
Create a password for this user
```shell
aws iam create-login-profile --user-name lambda_user --password My!User1Login8P@ssword
```
Create an CLI access key for this user
```shell
aws iam create-access-key --user-name lambda_user
```
Save the Secret and Access Key's some where safe

AWS allows users to perform operations defined by a policy. We are going to create a custom policy and pass it to our user.

Create our policy granting all the lambda functionality
```shell
cat > lambda_policy.json <<EOF
{
   "Version": "2012-10-17",
   "Statement": [{
       "Effect": "Allow",
       "Action": [
          "iam:*",
          "lambda:*"
       ],
       "Resource": "*"
   }]
}
EOF
```
Grant this policy to our lambda_user
```shell
aws iam put-user-policy --user-name lambda_user --policy-name lambda_all --policy-document file://lambda_policy.json
```
Next we will configure our AWS cli to this user.
```shell
aws configure --profile lambda_user
> AWS Access Key ID [None]: <your_key>
> AWS Secret Access Key [None]: <your_secret>
> Default region name [None]: ap-southeast-1 
> Default output format [None]: json 
```
 Lambda functions also need a role. The role specifies what actions the function instance is capable of.
 ```shell
cat > basic_lambda_role.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": { "AWS" : "*" },
        "Action": "sts:AssumeRole"
    }]
}
EOF

aws iam create-role --role-name basic_lambda_role --assume-role-policy-document file://basic_lambda_role.json

```
save this output as "Arn" for lambda function "arn:aws:iam::xxxxxxxxxx:role/basic_lambda_role"
