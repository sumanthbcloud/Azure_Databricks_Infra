# Azure Databricks Infrastructure with Terraform

This repository sets up a complete Azure Databricks workspace, a single-node cluster, secure networking, and data lake storage using Terraform.

If you are cloning this repository, you don't need any complex setup. You just log into Azure from your terminal and run `terraform apply`. In about 10–15 minutes, you'll have a working Databricks environment ready for notebooks and data jobs.

---

## What Gets Created

When you deploy this code, it builds five things in Azure:

1. **Resource Group (`lakehouse-rg`)**: A single container in Azure that holds all the resources for this project, keeping everything clean and easy to delete later.
2. **Virtual Network (`lakehouse-vnet`)**: A private network with two subnets and a NAT gateway. Databricks runs inside this private network instead of the public internet.
3. **Databricks Workspace (`lakehouse-dbx`)**: Your main web interface where you write notebooks, run SQL queries, and manage data.
4. **Compute Cluster (`lakehouse-cluster`)**: A single-node machine running Databricks Runtime with Photon. It's pre-configured and starts automatically so you can run code right away. It also auto-shuts down after 3 hours of inactivity to save cost.
5. **ADLS Gen2 Storage Account (`sumanthbmedallion`)**: A cloud storage account with a container named `lakehouse`. The code automatically grants your own Azure account full read and write access (`Storage Blob Data Contributor`), so you don't have to fiddle with role permissions in the Azure portal.

---

## Repository Structure

```text
Azure_Databricks_Infra/
├── modules/                   # Reusable infrastructure building blocks
│   ├── resource-group/        # Creates the Azure Resource Group
│   ├── vnet/                  # Sets up the VNet, subnets, NSGs, and NAT gateway
│   ├── adls-gen2/             # Creates storage and assigns your user permissions
│   ├── databricks-workspace/  # Creates the workspace with VNet injection
│   └── databricks-cluster/    # Creates the single-node compute cluster
│
└── infra/                     # Root deployment environment
    ├── main.tf                # Connects all modules together in proper sequence
    ├── variables.tf           # Variable definitions with defaults
    ├── terraform.tfvars       # User values (names, region, storage, CIDRs)
    ├── providers.tf           # Azure and Databricks provider setup
    └── outputs.tf             # Prints links and IDs when apply finishes
```

---

## What You Need Installed First

Before you start, make sure you have these two free tools on your machine:

### 1. Azure CLI (`az`)
Used to log into your Azure account from your terminal.
- **Mac**: `brew install azure-cli`
- **Windows**: `winget install -e --id Microsoft.AzureCLI`
- **Linux**: `curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`

### 2. Terraform (version 1.8 or higher)
Used to read the files and build the resources.
- **Mac**: `brew tap hashicorp/tap && brew install hashicorp/tap/terraform`
- **Windows**: `winget install -e --id HashiCorp.Terraform`
- **Linux**: Follow the official [HashiCorp Linux install guide](https://developer.hashicorp.com/terraform/install).

To make sure both are installed properly, run these two commands in your terminal:
```bash
az version
terraform -version
```
If both return version numbers, you're all set.

---

## How to Deploy (Step by Step)

### Step 1: Open Your Terminal
Open Terminal (on Mac/Linux) or PowerShell (on Windows) and clone the project repo from github:
```bash
using git clone
```

```bash
cd Azure_Databricks_Infra
```

### Step 2: Log into Azure
Run:
```bash
az login
```
A browser window will open automatically. Sign in with your Azure account. Once you see the success message, you can close the browser tab and return to your terminal.

*(If you have more than one Azure subscription, pick the one you want: `az account set --subscription "<SUBSCRIPTION_ID>"`)*

Clone the repo from github. 

### Step 3: (Optional) Review Settings
Open `infra/terraform.tfvars` in any text editor. It looks like this:

```hcl
# Azure Region
location = "southcentralus"

# Resource Names (change these if you want custom names)
resource_group_name = "lakehouse-rg"
vnet_name           = "lakehouse-vnet"
workspace_name      = "lakehouse-dbx"
cluster_name        = "lakehouse-cluster"

# Network CIDRs
vnet_address_space        = ["10.20.0.0/16"]
host_subnet_prefixes      = ["10.20.1.0/24"]
container_subnet_prefixes = ["10.20.2.0/24"]

# Databricks Compute Settings
cluster_node_type_id            = "Standard_D4ds_v4"
cluster_autotermination_minutes = 180

# ADLS Gen2 Storage
adls_gen2_account_name    = "sumanthbmedallion"
adls_gen2_filesystem_name = "lakehouse"
```

**A quick note on the storage account name:**
Azure requires storage account names to be unique across all users worldwide (just like a website domain name). For now, it's set to `sumanthbmedallion`. You can keep it as is. If you ever get an error saying the name is already taken, just change it to something unique to you (lowercase letters and numbers only, 3 to 24 characters).

### Step 4: Initialize Terraform
Move into the `infra` folder and initialize:
```bash
cd infra
terraform init
```
This downloads the Azure and Databricks plugins. It usually takes about 10–20 seconds.

### Step 5: Preview Changes (Optional)
To preview exactly what Terraform will create before making any real changes to your Azure account, run:
```bash
terraform plan
```
Terraform will perform a dry run and print a summary showing that 19 resources will be added. No resources are created in Azure during this step.

### Step 6: Build Everything
Now run the command to build your infrastructure:
```bash
terraform apply
```
*(Tip: You can also use `terraform apply --auto-approve` to automatically approve and skip the confirmation prompt).*

Terraform will show the execution plan and ask for confirmation at the bottom:
```text
Enter a value:
```
Type `yes` and press Enter (not needed if you used `--auto-approve`).

**Note:** The deployment takes about 10 to 15 minutes.

### Step 7: Access Your Workspace
When the apply finishes, Terraform will print the outputs directly in your terminal:

```text
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

adls_gen2_account_name    = "sumanthbmedallion"
adls_gen2_filesystem_name = "lakehouse"
databricks_cluster_id     = "..."
databricks_cluster_url    = "https://adb-....net/#setting/clusters/..."
databricks_workspace_url  = "https://adb-....net"
resource_group_name       = "lakehouse-rg"
vnet_name                 = "lakehouse-vnet"
```

1. Copy the `databricks_workspace_url` into your browser.
2. Sign in with your Azure account.
3. Click **Compute** on the left menu, and you'll see your cluster (`lakehouse-cluster`) up and running.

---

## Deleting Everything (Clean Up)

When you're finished experimenting and want to avoid any Azure costs, you can delete all resources with a single command:

```bash
cd infra
terraform destroy
```
*(Or `terraform destroy --auto-approve` to skip the confirmation prompt).*

When asked to confirm, type `yes` and press Enter. Terraform will delete the cluster, workspace, virtual network, and storage account cleanly.

---

## Common Questions & Quick Fixes

- **"Storage account name is already taken"**:
  Open `infra/terraform.tfvars`, change `adls_gen2_account_name = "sumanthbmedallion"` to another name (e.g. your name with a couple of numbers), and run `terraform apply` again.
- **Why did it pause for 3 minutes during apply?**:
  Databricks takes a couple of minutes to configure its internal routing after the workspace is created. The pause prevents cluster creation from failing.
- **Will the cluster cost me money if I forget to stop it?**:
  The cluster is configured to auto-stop after 3 hours (180 minutes) of inactivity. If no notebooks are running, it automatically turns off.

---

## Author
Maintained by [sumanthbcloud](https://github.com/sumanthbcloud).
