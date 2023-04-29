
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



# STEPS To Follow Up 

1. First create a Aws connection with the github repository in which all your code is exists. keep both the buildspec files for prod and dev env in root folder and create a folder `terraform-tf-file` and paste all tf files in it.

2. Now Go to systems manager and select parameter store and create 2 paramters there. we are creating this parameters so that we can use our aws account access key and secret access key in which our resources are going to deploy. create one with `/CodeBuild/MY_AWS_ACCESS_KEY_ID` and choose secure string there and paste the access key id there and create 2nd with name `/CodeBuild/MY_AWS_SECRET_ACCESS_KEY` and paste secret access key. We are choosing these names beacause we already mentioned these names in our buildpec files under env block.

3. Now create 2 dynamo db tables with the names which are metioned dev.conf and prod.conf and name the partion key as `LockId`and also create s3 bucket with same name mentioned in these conf files.


4. Then go to Aws Codepipeline and create a new pieline. Choose github (version 2) for the source provider and then select the connection which you create recently and also choose the repo and branch.

5. Make sure to choose this option (tick the box) `Start the pipeline on source code change`

6. Choose AWS Codebuild for the build stage and create a new project. Name it as per your needs. Select `Managed Image` for enviorment image and select `Amazon Linux 2` for the operating system. Runtime will be standard and choose the latest image. For the service role choose the new service role and for th buildspec file enter the name of the dev buildspecfile which is `dev-buildspec.yaml` and enable the cloudwatch logs and click on `Continue to codepipeline`

7. After selecting the `single build` click on next button.

8. On the next step click on `skip the deploy stage` because we are only using the codebuild to deploy this app and create pipeline. (before clicking on create pipeline first make sure that in your both buildspec files under section `env` the TF_COMMAND: "apply" should be apply because we have to create the resource with apply command.

9. Now you will see that your pipeline is started , first it will fetch the code from your github and then it will move to the 2nd stage which is build and it will failed becuase the iam role attached to codebuild has no permissions to access/read the systems managers parameters store. So now we need to provide the required permissions to the codebuild to read parameters. create a new policy which has read permissions for the parameters store and attach this policy to the iam role.

10. After attaching the policy to the role of the codebuild project , go to pipeline and click on release change to initiate the pipeline again.

11. It will take approx 10 mins and you can see that all the `dev` resources got deployed , you can monitor all the resources.

URLs to access the app : 

https://dev.jasmeetdevops.com/
https://dev.jasmeetdevops.com/app1/index.html
https://dev.jasmeetdevops.com/app1/metadata.html




## Deploying Prod related resources 

1. Next we need to deploy our resources in `prod` env. So for this got to `SNS` topic and create a new topic and subscription.

2. Go to your pipeline and edit the pipeline. After the `Edit: build` add a stage & name it manual approval. Then click on `Add action group` and name the action and for the action provider choose the `manual approval` and under `SNS` choose the topic which you created at first step and click on `done`.

3. Now after the EDIT: manual , add another stage in the last and name it `prod-build`. Click on the add action group and give it a name and for the `action provider` choose `AWS Codebuild` and choose/click on the `Create New project` and it will take you to the codebuild page to create a project.

4. Create this new project with name `prod-build` and choose all the settings as we created our previous first project. And for the `buildspec file` make sure you have to name it `prod-buildspec.yaml` because we are now using the prod env. click on create project. When this project will get created , got the `IAM role` of this new project and attatch the ssm read policy which we created priviously for our dev project so that this role also have the required permissions to read the parameters form system managers.

5. Then you will be redirected to your pipeline page and click on done. Now you stages have been added and click on `save` button to save these changes. 

6. Click on `Release Change` and monitor the pipeline. First it will fetch from github and then it will go the build stage which is our already deployed dev env and after this it will go the `manual approval` stage , this this the stage where we have to approve it manually to deploy the `Prod` anv as well.

7. When your pipeline passes the dev build stage it stay on manual approval stage , you can click on review and add optional comments and approve this and this will pass to the build your prod env.

8. Now you can sse that all the resources for your dev and prod env with differnet names should be created successfully, Prod app can be accessible at below URLs: 


https://prod.jasmeetdevops.com/
https://prod.jasmeetdevops.com/app1/index.html
https://prod.jasmeetdevops.com/app1/metadata.html

## You can check the tfstate files are stored in s3 bucket in specific env folder --- dev and prod

## Destroying the enviorments

1. Now we are going to destroy the our resources.

2. For this got to your github repo and in both buildspec files comment the line TF_COMMAND: "apply" and add a new line under it 
TF_COMMAND: "destroy". This line should be in your both prod and dev buildspec files.

3. After making the changes , commit and push the changes and you will see that the your pipeline will trigger again and this will destroy all the resources which are created priviously.(Make sure to approve the `manual approval stage` after the dev build stage)

4. Make sure all the resources got deleted. If , Yes , then delete your pipeline , codebuild project , s3 bucket , SNS topic and AWS connection for github. Also Delete `Dynamo db` tables and `Parameters` in `Systems Managers`..


## Thanks for follow up.





