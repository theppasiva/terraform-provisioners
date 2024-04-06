resource "aws_instance" "web" {
  ami           = "ami-0f3c7d07486cad139" #devops-practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop-all.id]

  tags = {
    Name = "provisioners"
  }

  provisioner "local-exec" {
    command = "echo  this will execute at the time of creation, you can trigger other system like email and sending alerts" #self = aws_instance
  }

  provisioner "local-exec" {
    command = "echo  ${self.private_ip} > inventory" #self = aws_instance
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i inventory web.yaml" #self = aws_instance
  # }

  provisioner "local-exec" {
    when = destroy
    command = "echo  this will execute at the time of destroy, you can trigger other system like email and sending alerts" #self = aws_instance
    
  }

  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'this is from remote exec' . /tmp/remote.txt",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
}

  resource "aws_security_group" "roboshop-all" {
    name = "provisioner"
    description = "allowing to connect from laptop"

    ingress {
      description = "Allow all ports"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow all ports"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "provisioner"
    }

  }



