provider "aws" {
	region = "ap-south-1"
	profile = "default"
}

resource "aws_instance" "k8s_master" {
  #count = 1
  ami           =  "ami-04db49c0fb2215364"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_TCP.id]
  #security_groups  = [" kubernetes_sg "]
  subnet_id = aws_subnet.main.id
  key_name      = "aws_k8s"
  tags = { 
      Name  = " kubernetes_master "
}
/*
connection {
  host = self.public_ip
  type = "ssh"
  user = "ec2-user"
  private_key= file("/root/key/aws_k8s.pem")
 # host = aws_resource.k8s_master.public_ip
}

provisioner "remote-exec" {
inline = [
	" sudo su - root "
]
}

#provisioner "local-exec" {
#      command =  "ansible-playbook -i ${aws_instance.k8s_master.public_ip}, --private-key aws_k8s.pem  master.yml"

#}
*/
}

resource "aws_ebs_volume"  "k8s_ebs" {
  availability_zone  = aws_instance.k8s_master.availability_zone
  size = 5
  tags = {
     Name = "k8s_ebs_volume"
    }
}


resource    "aws_volume_attachment"   "ebs_attach"  {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.k8s_ebs.id
  instance_id  = aws_instance.k8s_master.id
  }


resource "aws_instance" "k8s_slave" {
  count = 2
  ami           =  "ami-04db49c0fb2215364"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_TCP.id]
  #security_groups  = [" kubernetes_sg "]
  subnet_id = aws_subnet.main.id
  key_name      = "aws_k8s"
  tags = {
      Name  = " kubernetes_worker "
}
}
