## 1. vpc_cidr
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

##2. public_subnet_cidrs
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

## 3. private_subnet_cidrs
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

## 4. availability_zones
variable "availability_zones" {
  description = "List of availability zones to use for high availability."
  type        = list(string)
}
