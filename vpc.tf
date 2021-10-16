resource "aws_vpc" "main" {
    cidr_block =  var.vpc_cidr
    tags = {
        Name = "k8s_vpc"
    }
}

resource "aws_internet_gateway" "k8s_gw" {
    vpc_id = aws_vpc.main.id
    tags={
        Name = "k8s_vpc_igw"
    }
}


resource "aws_subnet" "main" {
    #count = length(var.subnet_cidr)
    vpc_id = aws_vpc.main.id
    #cidr_block = element(var.subnet_cidr , count.index)
    #availability_zone = element(var.availability_zones , count.index)
    cidr_block = var.subnet_cidr
    availability_zone = var.availability_zones
    map_public_ip_on_launch = true
    
    tags = {
	Name = "Subnet-1"
     
    }

}

resource "aws_route_table" "RT" {  
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s_gw.id
    }
}

resource "aws_route_table_association" "a" {
    count = length(var.subnet_cidr)
    subnet_id = element(aws_subnet.main.*.id , count.index)
    route_table_id = aws_route_table.RT.id
}
