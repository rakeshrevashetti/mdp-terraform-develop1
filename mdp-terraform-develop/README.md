# TERRAFORM TEMPLATES

  - Apply terraform templates to create quick, scalabale and incremental infrastructure for alstom mobility data platform
  - Choose from templates

### How to install terraform
- On Windows download terraform binary from - [Terraform Download](https://www.terraform.io/downloads.html)
- Once downloaded, extract the binary and make it globally executable on windows, set the binary in PATH - [Set Terraform to global executable](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows)
- Because of Alstom network restrictions, you wont be able to download terraform plugins for Azure, and thus the plugins have been uploaded in the repositories itself
- If not in alstom network you can initialize using terraform init

### How to use terraform for AMDP
- Clone the required repository
- Traverse inside the folder(for example - cd multi-node)
- `> terraform init`
- Modify **var_values.tfvars** for user variables and inputs. Secrets are stored locally on secret.tfvars
- `> terraform get`
- This would pull all the required modules
- `> terraform plan -var-file=secret.tfvars –var-file=var_values.tfvars`
- If the plan looks good you can go ahead and do `terraform apply -var-file var_values.tfvars`
- To destroy the infrastructure created using **tfvars** we do `terraform destroy -var-file=secret.tfvars -var-file=var_values.tfvars`
 
### Development Process
- Raise a JIRA ticket for the terraform feature development you are creating - [Mobility Data Platform Kanban](https://smartmobility.atlassian.net/secure/RapidBoard.jspa?projectKey=MDP&rapidView=2)
- Use terraform branch in project amdp-devops. Create a feature branch using the JIRA ticket. This branch should be created from develop.
- Naming convention to be followed - **feature/MDP-X**
- Once the development is done raise a pull request.
- **Note - Dont merge to develop without pull request approval.**
