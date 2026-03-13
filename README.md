### Project Structure

```text
task1-asg/
├── .gitignore
├── README.md
│
├── packer/                  #Golden Image build
│   ├── llm-ami.pkr.hcl      # Packer template for Ubuntu + Docker + LLM
│   └── scripts/             
│       ├── install_docker.sh
│       └── setup_llm.sh     # Script to pull models and prepare OpenWebUI
│
└── terraform/
    ├── backend-setup/       # ONE-TIME SETUP FOR REMOTE STATE RESOURCES
    │   ├── main.tf          # S3 Bucket & DynamoDB Table
    │   ├── providers.tf
    │   ├── variables.tf 
    │   └── outputs.tf
    │
    ├── backend.tf           # Remote state configuration
    ├── main.tf              # Root
    ├── providers.tf
    ├── variables.tf
    ├── outputs.tf
    │
    └── modules/
        ├── networking/      # VPC, Subnets, Gateways, and Route Tables
        │   ├── vpc.tf
        │   ├── subnets.tf
        │   ├── gateways.tf
        │   ├── route_tables.tf
        │   ├── variables.tf
        │   └── outputs.tf        
        ├── compute/         # EC2, ASG, ALB, Security Groups, and IAM
        │   ├── security_groups.tf
        │   ├── bastion.tf
        │   ├── alb.tf
        │   ├── asg.tf
        │   ├── iam.tf
        │   ├── variables.tf
        │   └── outputs.tf
        └── database/        # RDS PostgreSQL and SSM Secrets
            ├── rds.tf
            ├── secrets.tf
            ├── variables.tf
            └── outputs.tf
```
