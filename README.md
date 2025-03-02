# vcc-ass-2

# GCP Auto-Scaling VM Instance with Terraform

This repository contains Terraform code to create a VM instance on Google Cloud Platform (GCP) with auto-scaling policies, security measures, and a simple web application deployment.

### 1. Prerequisites

1. GCP Account: Ensure you have a GCP account and a project created.
2. Terraform Installed: Install Terraform on your local machine.
3. GCP Credentials : Download the service account key JSON file from GCP and ensure it has the necessary permissions to create resources.


### 2. Update the Terraform Configuration

Replace the following placeholders in the `main.tf` file with your GCP project details:

- Project ID: Replace `"m23aid055-pritish-vcc-ass2"` with your GCP project ID.
- Credentials: Replace `"/Users/pktsangs/Downloads/m23aid055-pritish-vcc-ass2-7be51308fb86.json"` with the path to your GCP service account key JSON file.
- Region/Zone* Replace `"us-central1"` and `"us-central1-a"` with your desired region and zone.

### 3. Initialize Terraform

Run the following command to initialize Terraform and download the necessary providers:

```bash
terraform init
```

### 4. Review the Execution Plan

Run the following command to see the execution plan:

```bash
terraform plan
```

This will show you the resources that Terraform will create.

### 5. Apply the Configuration

Apply the Terraform configuration to create the resources:

```bash
terraform apply
```

Type `yes` when prompted to confirm the creation of resources.

### 6. Verify the Resources

Once the Terraform script completes, verify the following resources in your GCP console:

- VPC Network: A VPC network named `m23aid055-my-vpc-network` will be created.
- Firewall Rules: Two firewall rules will be created to allow HTTP (port 80) and SSH (port 22) traffic.
- Instance Template: An instance template named `m23aid055-my-instance-template` will be created.
- Managed Instance Group (MIG): A MIG named `m23aid055-my-mig` will be created with auto-scaling policies.
- Health Check: A health check named `m23aid055-my-health-check` will be created to monitor the instances.

### 7. Access the Web Application

Once the instances are up and running, you can access the web application by navigating to the public IP address of the instance group in your web browser.

### 8. Clean Up

To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

Type `yes` when prompted to confirm the destruction of resources.

## Security Measures

1. IAM Roles: Ensure that the service account used has the minimum necessary permissions to create and manage resources.
2. Firewall Rules: Firewall rules are configured to allow HTTP and SSH traffic only. Adjust the `source_ranges` to restrict access to specific IP ranges if needed.

## Auto-Scaling Policies

The auto-scaling policy is configured to scale the number of instances based on CPU utilization:

- Min Replica: 1
- Max Replicas: 8
- Target CPU Utilization: 50%

The instances will scale up when the CPU utilization exceeds 50% and scale down during periods of low usage.

## Health Check

A health check is configured to monitor the health of the instances. If an instance fails the health check, it will be automatically replaced.

## Output

The public IP address of the instance group will be displayed as an output after running `terraform apply`.

## Troubleshooting

- Terraform Errors: Ensure that your GCP credentials are correct and that the service account has the necessary permissions.
- Instance Not Reachable**: Check the firewall rules and ensure that the instance is running and healthy.

