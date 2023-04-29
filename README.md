
## AWS CODEPIPELINE WITH TERRAFORM

In this Demo, we are going to use AWS code pipeline with Terraform. 

AWS CodeBuild to deploy our application and we are using the terraform files for two different environments. Prod and Dev. 

IN root folder there is a directory called terraform-tf-files in which all our terraform configuration files are present. The first file is prod-buildspec.yaml and second file is dev-buildspec.yaml. So these two files are used in the CodeBuild, in this way we are going to deploy two different environments using AWS CodePipeline. 

## Use Github or CodePipeline to deploy this simple app
The dev env will be available at dev.jasmeetdevops.com and prod will be available at prod.jasmeetdevops.com after deployment.In the end `AWS CODEBUILD` is going to deploy out tf files.

## Buildspec files:- 
In the buildspec files in the first block we are using the environment block we are declaring the environment variables like terraform version and the terraform command. The next block is phases , in the install phase we are going to install the python 3.9. And also we are going to install the latest terraform version and after that we are unzipping the terraform file and moving it to the usr/local/bin. 
The next phase is pre build. In this phase we are going to run a simple command that terraform execution is started with date command. The next phase is build phase. So this is the phase in which first we are going to the terraform-tf-files directory and we are checking the terraform version. Then we are executing terraform init -input=false --backend-config=dev.conf. This flag --backend-config is resposible to create different enviroments.After this we are executing terraform validate and plan command with the tfvars file (dev or prod) and finaly we are deploying tf files with terraform apply command and here apply and destroy command can be used as i used here a env variable for command. 
In PostBuild phase we are just executing echo command that all execution is completed.

## Terraform files 


1. vpc.tf :-`This tf file is used for creating all VPC related resources. I am using VPC module (version-"3.19.0") in this file. You can check all inputs that i am providing in the file and i used varibales for most of the resources.This will create public and private subnets , NAT gateway for private instances which i am also going to create`


2. vpc-outputs.tf:- `This file contains all the outputs of VPC, that can be usefull for us for any task e.g Ids of public and private subnets, vpc-id , NAT gateway ip , availability zones and CIDR blocks`

3. SG-bastionhost.tf:- `This file is used to create a security group for public ssh access on port 22 for our bastion host`

4. bastion-host.tf:- `This file is for public instance and it is a Aws Ec2 module in terraform that i am using to create a ec2 instance`

5. data-source-ami.tf:- `In this file we are using datasource to get the latest AMI id from AWS for our ec2 instances`

6. data-source-route53.tf:- `As i already have a hosted zone in route53 , so i am using this data source to get the id of the hosted zone and also output the name and id of the hosted zone `


7. ec2-outputs.tf:- `Outputs related to ec2 instances like public , private IPs etc.`

8. route53-dns-register:- `This file is used to create A record in our hosted zone and name is apps.jasmeetdevops.com and also will create a alias for this record with our alb dns name`

9. route53-acm-register.tf:- `This file is used to create a ssl certificate for our dns name and also it will verify/validate the ssl certifciate`

10. SG-private-ec2.tf:- `This file is creating a private security group for private instances and allowing traffic internally within/from vpc on port 80 and 22`

11. SG-alb.tf:- `Security Group for application load balancer which is opened for all traffic on http and https port from world`

12. ALB.tf:- `Create a ALB and 2 target groups. 2 instances for app1 will register in app1 target group and 2 instances for app2 will register in app1 target group. Also there will be 2 listners will create and also adding certificate with https listners`

13. ALB-outputs.tf:- `Outputs related to alb`

14. SG-outputs.tf:- `outputs related to security groups`

15. ASG-resource.tf:- `Auto scaling resource creation file`

16. ASG-launch-template.tf:- `Launch template resource creation file`

17. ASG-outputs.tf:- `outputs related to auto scaling group`

18. ASG-notifications.tf:- `Creation of a SNS topic with a unique name used random pet resource for name in this file and creation of subscription as well and also creation of auto scaling related notifications`

19. ASG-ttsp.tf:- `Creation of target tracking scaling policy with 2 types , cpu scaling policy and alb requests scaling policy`

20. app1-user-data.sh:- `user data script for parivate instances`

21. remote-exec.tf:- `This is null provider. By using null provider of terraform i am copying the pem key which will be used to connect to all instances to bastion host using local exec and also on same hand using remote exec i am applying required permissions to the key also`

22. locals.tf:- `Mostly tags are used as locals`

23. private_key:- `pem key for insatnces`

24. providers.tf:- `required providers used here like aws & local and random_pet resource`

25. common-variables.tf : `In this file we have created all the varibales used in this demo like variables for vpc ,ec2 and we declared the values of all the variables in tfvars files for both enviorments prod and dev`

26. dev.conf : `This file is used to declare the remote s3 backend information. While initializing the terraofrm we need to use this file as terraform init --backend-config=dev.conf`

27. dev.tfvars: `environment variables for dev env`

28. prod.conf: `This file is used to declare the remote s3 backend information. While initializing the terraofrm we need to use this file as terraform init --backend-config=prod.conf`

30. prod.tfvars: `environment variables for prod env`.






