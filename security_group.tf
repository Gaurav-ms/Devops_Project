variable "k8s_security_group_ports" {
  type = list
  default = [22,80,81,443,8080,8081]
}
resource "aws_security_group" "allow_TCP" {
  name        = "kubernetes_sg"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
      Name = "k8s_sg"
  }

  dynamic "ingress" {
    for_each = var.k8s_security_group_ports

    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
  dynamic "egress" {
    for_each = var.k8s_security_group_ports
    
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
}
