# TERRAFORM TEMPLATES

  - Apply terraform templates to create quick, scalabale and incremental infrastructure for alstom mobility data platform
  - Choose from templates ministation and mobility production cloud

### How to install terraform
- On Windows download terraform binary from - [Terraform Download](https://www.terraform.io/downloads.html)
- Once downloaded, extract the binary and make it globally executable on windows, set the binary in PATH - [Set Terraform to global executable](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows)
- Because of Alstom network restrictions, you wont be able to download terraform plugins for Azure, and thus the plugins have been uploaded in the repositories itself
### Prerequisites for using terraform
- We are using terraform integration with azure cli for a secure access to azure resource APIs, so you should have azure cli downloaded on your system
- Login to azure CLI
- `az login`
- Select the subscription we want to use - we are using SM-Mainline
- `az account set = "Subscription ID od SM-Mainline`
### How to use terraform for AMDP
- Clone the required repository
- Traverse inside the folder - ministation or mobility cloud
- `> terraform init`
- Modify **var_values.tfvars** for user variables and inputs
- `> terraform plan –var-file var_values.tfvars`
- If the plan looks good you can go ahead and do `terraform apply -var-file var_values.tfvars`
- To destroy the infrastructure created using **tfvars** we do `terraform destroy -var-file var_values.tfvars`
 
### Development Process
- Raise a JIRA ticket for the terraform feature development you are creating - [Mobility Data Platform Kanban](https://smartmobility.atlassian.net/secure/RapidBoard.jspa?projectKey=MDP&rapidView=2)
- Use amdp-devops-playbooks branch. Create a feature branch using the JIRA ticket. This branch should be created from develop.
- Naming convention to be followed - **feature/MDP-X**
- Once the development is done raise a pull request.
- **Note - Dont merge to develop without pull request approval.**
