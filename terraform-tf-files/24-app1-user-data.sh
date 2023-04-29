#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1> Welcome to DevOps World with JA$MEET ...!! </h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to <span style="color: #0000ff;">APP 1</span>&nbsp;</h1> <p>&nbsp;</p> <h3><em><strong><span style="color: #ff0000;">Jasmeet - The DevOps Engineer <img src="https://html-online.com/editor/tiny4_9_11/plugins/emoticons/img/smiley-cool.gif" alt="cool" /></span></strong></em></h3> <p>&nbsp;</p> <h2><span style="color: #339966;">I am a Life Long Learner</span></h2> </body></html>' | sudo tee /var/www/html/app1/index.html

sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html