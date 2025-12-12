
### Provider ####
provider "aws" {
  region = "eu-central-1"

  # --- SANDBOX SOLUTION: Force Skipping Validation ---
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

### Outputs de la Raíz ###
output "public_ip_for_login_service" {
  value = module.network.public_subnet_ids
}

# --- Define DB Secrets (for Sandbox) ---
variable "db_master_user" { default = "admin" }
variable "db_master_pass" { default = "s3cureP@ssword" }

### Llamadas a Módulos (En Orden) ###

# 1. Call Network Module
module "network" {
  source = "./modules/network"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
}

# 2. Call Database Module
module "database" {
  source = "./modules/database"

  # Pass outputs from 'network' as inputs to 'database'
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  # DB inputs
  db_username = var.db_master_user
  db_password = var.db_master_pass
}

# 3. Call IAM Module
module "iam" {
  source = "./modules/iam"
}

# 4. Call the Compute Module (TODOS los inputs están DENTRO de las llaves)
module "compute" {
  source = "./modules/compute"

  #### Entradas de Red y DB ####
  vpc_id                     = module.network.vpc_id
  public_subnet_ids          = module.network.public_subnet_ids
  database_security_group_id = module.database.db_security_group_id
  
  #### Entradas de Configuración de Cómputo ###
  ami_id        = "ami-0abcdef1234567890" 
  instance_type = "t3.micro"
  key_name      = "your-ssh-key-name"

  # Entradas de Escalabilidad (ASG)
  min_size = 2 
  max_size = 4
  
  # --- IAM Input ---
  iam_instance_profile_arn = module.iam.instance_profile_arn
}