# init-infra

Initial configuration for ConversaDocs managed environment accounts on AWS.

- [init-infra](#init-infra)
  - [Overview](#overview)
  - [Setup](#setup)
    - [General Setup Steps](#general-setup-steps)
  - [Usage](#usage)
    - [Make commands](#make-commands)
  - [Troubleshooting](#troubleshooting)

## Overview

The `init-infra` repository contains Terraform configurations to set up the foundational AWS infrastructure for ConversaDocs. It automates the creation of AWS Organizations, Organizational Units (OUs), accounts for different environments (like development, testing, and production), and applies Service Control Policies (SCPs) to enforce governance and security best practices across the organization.

By leveraging this infrastructure-as-code approach, we ensure consistency, scalability, and compliance throughout our AWS environments.

## Setup

To set up this repository and run the Terraform configurations locally, you'll need to have the following tools installed on your machine:

- **Terraform**
- **pre-commit**
- **Checkov**
- **terraform-docs**
- **TFLint**

These tools are required to enforce code quality, security scanning, and documentation standards. Detailed installation instructions are provided in the `CONTRIBUTING.md` file.

### General Setup Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/conversadocs/init-infra.git
   cd init-infra
   ```

2. **Install Pre-commit Hooks**

   ```bash
   pre-commit install
   ```

3. **Verify Tool Installation**

   Ensure that all required tools are installed and accessible in your PATH. You can verify by running:

   ```bash
   terraform version
   pre-commit --version
   checkov --version
   terraform-docs --version
   tflint --version
   ```

4. **Tfvars**

    Check for any variables without a default value and add the required `*.tfvars` file to provide those values.

## Usage

After completing the setup, you can use the following Terraform commands to manage the infrastructure:

1. **Initialize Terraform**

   Initialize the Terraform working directory to download necessary providers and modules.

   ```bash
   terraform init
   ```

2. **Validate the Configuration**

   Check that the Terraform files are syntactically valid and internally consistent.

   ```bash
   terraform validate
   ```

3. **Review the Execution Plan**

   Generate and review the execution plan to see what actions Terraform will perform.

   ```bash
   terraform plan
   ```

4. **Apply the Configuration**

   Apply the changes required to reach the desired state of the configuration.

   ```bash
   terraform apply
   ```

   Confirm the apply action when prompted.

**Note:** Ensure that your AWS credentials are correctly configured and that you have the necessary permissions to create and manage AWS resources.

### Make commands

For convenience a series of `make` commands have been provided to streamline and simplify usage of this code. For a complete listing of commmands run `make help`.

## Troubleshooting

If you encounter issues while using this repository, consider the following steps:

- **Check Tool Installations**

  Verify that all required tools are installed and are of the correct versions as specified in the `CONTRIBUTING.md` file.

- **AWS Credentials**

  Ensure that your AWS credentials are set up correctly and have the necessary permissions. You can configure credentials using environment variables, AWS CLI configuration files, or AWS SSO.

- **Pre-commit Hook Failures**

  If pre-commit hooks fail, you can run them manually to get detailed error messages:

  ```bash
  pre-commit run --all-files
  ```

- **Terraform Errors**

  - **Initialization Errors:** If `terraform init` fails, ensure that you have network connectivity and access to required providers and modules.
  - **Plan or Apply Errors:** Review the error messages for details. Common issues include missing variables or insufficient permissions.

- **Common Issues**

  - **Linting Errors:** Run `tflint --format stylish --module .` to view linting issues.
  - **Security Scan Failures:** Use `checkov -d .` to scan for security configuration issues.

If issues persist, please refer to the `CONTRIBUTING.md` file for more detailed guidance. You can also open an issue in the repository with detailed information about the problem and the steps you've taken to resolve it.
