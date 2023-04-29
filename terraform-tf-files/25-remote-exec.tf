# these provisioners are used to send pem key to bastion host
# we are going to use null resource for our provisioner here
resource "null_resource" "test-null" {
  depends_on = [module.ec2_instance]

  # this block is used to connect to our remote host which is bastion host
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    host        = module.ec2_instance.public_ip
    private_key = file("private_key/terraform-key.pem")
  }

  # this block will copy the pem file on bastion host
  provisioner "file" {
    source      = "private_key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }

  # this block will change the permissions on pem file after sending the pem file on bastion host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem",
    ]
  }
}
