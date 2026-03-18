### Project Structure

```text
task1-asg/
├── .gitignore
├── README.md
│
├── packer/                      # Golden Image build
│   ├── llm-ami.pkr.hcl
│   ├── open-webui.service       # Systemd
│   └── setup_llm.sh             # Model setup script
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
        │   ├── security_groups.tf
        │   ├── subnets.tf
        │   ├── gateways.tf
        │   ├── route_tables.tf
        │   ├── variables.tf
        │   └── outputs.tf
        ├── compute/         # EC2, ASG, ALB, and IAM
        │   ├── key-pair.tf
        │   ├── bastion.tf
        │   ├── alb.tf
        │   ├── asg.tf
        │   ├── iam.tf
        │   ├── userdata.sh.tftpl
        │   ├── variables.tf
        │   └── outputs.tf
        └── database/        # RDS PostgreSQL and SSM Secrets
            ├── rds.tf
            ├── secrets.tf
            ├── variables.tf
            └── outputs.tf
```
