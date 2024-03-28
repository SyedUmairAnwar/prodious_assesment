provider "aws"{
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  #we can set in out shell before running the terraform command. by using Export command. 
}

variable "region" {
description = "This is th edefault region if region will not provide"
default = "ap-south-1"
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow inbound traffic"
  vpc_id      = vpc-004f007fbcfd08f25

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysg"
  }
}

# Create Instance

resource "aws_instance" "dockerinstance" {
  ami           = "ami-025b4b7b37b743227"
  instance_type = "t2.micro"
  name = "Dockeweb"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.mysg.id]
  key_name = "syed"

  tags = {
    Name = "Dockeweb"
  }
}

# Create auto scaling group
resource "aws_autoscaling_group" "docker_scale" {
  name             = "docker-auto-scaling-group"
  launch_configuration = aws_instance.dockerinstance.name
  min_size         = 1
  max_size         = 5
  desired_capacity = 1  

}

# Create S3 bucket
resource "aws_s3_bucket" "docker_bucket" {
  bucket = var.bucket_name 
  acl    = "public"

  tags = {
    Name = "syedbukcet"
  }
}
# Create CloudFront distribution
resource "aws_cloudfront_distribution" "docker_distribution" {
  origin {
    domain_name = aws_s3_bucket.docker_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.docker_bucket.id}"
    s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3-${aws_s3_bucket.docker_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }
  tags = {
    Name = "docker-distribution"
  }
}
