# Project 19

## Automate Infrastructure With Iac Using Terraform Part 4 - Terraform Cloud
---


### What Terraform Cloud is and why use it
---

Terraform Cloud is a managed service that provides you with Terraform CLI to provision infrastructure, either on demand or in response to various events.


### Migrate your .tf codes to Terraform Cloud

---

Let us explore how we can migrate our codes to Terraform Cloud and manage our AWS infrastructure from there:

- Create a Terraform Cloud account
  
- Create an organization

  - Select "Start from scratch", choose a name for your organization and create it.
  
  - Configure a workspace
  
    ![](./screenshots/terraform_cloud_workspace.png)

- Select VCS and select the project [repo](https://github.com/stwalez/pbl_p19).

  - Ensure that the terraform working directory is set as the repo has a subfolder for Terraform files
    ![](screenshots/terraform_cloud_workspace2.png)

  - Configure variables
    ![](./screenshots/terraform-cloud-env-vars.png)

### Build the AMI for the servers using Packer

---

- Install Packer and Ansible latest versions on your OS

- Setup aws credentials on the CLI.

- Clone the [repo here](https://github.com/stwalez/pbl_p19) which has the prepared Packer, Ansible and Terraform scripts.

- Navigate to the Packer section and build the packer image

  ```
  cd AMI
  packer build bastion.pkr.hcl
  packer build nginx.pkr.hcl
  packer build web.pkr.hcl
  ```

- Verify that the packer build amis were created from the console

  ![](screenshots/terraform_packerbuilds_ami.png)

- Update the Terraform variables with the ami details

  ![](screenshots/terraform_update_vars.png)

- Validate adn format the terraform files
  ```
  terraform validate
  terraform fmt -recursive
  ```

- Push the code to GitHub to trigger Terraform Cloud Hook


- Once the Terraform Cloud has started the Plan, Click to Apply the run.

- Ensure that the following required outputs are generated, they would be required to configure Ansible

  ![](screenshots/terraform_cloud_output.png)


### Ansible Setup
- Configure your OS to allow SSH-Agent

  ```
  Get-Service ssh-agent | Set-Service -StartupType Manual
  Start-Service ssh-agent

  Get-Service ssh-agent
  ssh-add pbl-projects.pem

  ```
- Connect to the Bastion server generated via terraform in the previous step and ensure you can login

- Verify that the ssh keys are also accessible on the Bastion via the ssh agent
  
  ![](screenshots/ssh_agent.png)

- Check the ansible folder which is already git cloned during the ami build and update the variables in nginx, wordpress, tooling with the outputs from Terraform

  - nginx ansible role variables
    
    ![](screenshots/nginx_default_vars.png)

  - tooling ansible role variables
    
    ![](screenshots/tooling_default_vars.png)

  - wordpress ansible role variables
    
    ![](screenshots/defaults_var_wordpress.png)


- Run ```ansible-inventory -i inventory/aws_ec2.yml --graph```  to verify that AWS Instances dynamic IPs are discovered.

  Note: If no input is shown ensure ansible version is updated

- Run ```ansible-playbook -i inventory/aws_ec2.yml playbook/site.yml``` to start the ansible deployments
  ![](screenshots/bastion_ansible_setup.png)


- Verify that the site is accessible:
  ![](screenshots/wordpress_site.png)

  ![](screenshots/tooling_db_site.png)


### Practice Task No 1

---
- Configure 3 branches in your terraform-cloud repository for dev, test, prod environments
- 
  ![](screenshots/task1_branches.png)

- Make necessary configuration to trigger runs automatically only for dev environment
  - Set the VCS branch in the Terraform cloud workspace to the new branch
  
  ![](screenshots/task1-terraform_test_branch.png)

  - Push to the Github branch and observe the trigger
  
    ![](screenshots/task1-terraform_test_branch_plan_trigger.png)

- Create an Email and Slack notifications for certain events (e.g. started plan or errored run) and test it
  - Navigate to Workspace Settings > Notifications and select ```Create a Notification```

    ![](screenshots/terr_notifications_create.png)

  - Follow the guidelines to create a Slack Channel and create an incoming webhook

    ![](screenshots/task1_notifications_create_app_2.png)

  - Insert the notifications to Terraform Slack Destination Notification

    ![](screenshots/task1_notifications_create_app_3.png)

  - Trigger a Github Push to the test branch and observe the terraform plan run notifications sent to Slack
  
    ![](screenshots/task1_terraform_slack_notify.png)

- Apply destroy from Terraform Cloud web console


### Practice Task 2 Working with Private repository

---

- Create a simple Terraform repository  that will be your module
  - Fork the repo [here](https://github.com/hashicorp/learn-private-module-aws-s3-webapp)

    ![](screenshots//task2_fork_repo.png)

  - Tag the repo
    ![](screenshots/task2_tag_module.png)



- Import the module into your private registry

  - Navigate to Terraform Cloud Organization > Registry > Modules and select ```Add a VCS Provider``` if Github is not already linked to it
    
    ![](screenshots/task2_vcs_repo.png)

  - Set up modules by connecting to your VCS

    ![](screenshots/task2_connect_vcs_3.png) 

  - Select the forked repo (ensure it has been tagged in previous step)
   
    ![](screenshots/task2_add_module1.png)

  - Finish the import of the module
    
    ![](screenshots/task2_imported_module.png)


- Create a configuration that uses the module
  - Insert variables required by the module
    
    ![](screenshots/task2_configure_module.png)

  - Download Module config
    
    ![](screenshots/task2_download_module_config.png)

- Create a workspace for the configuration
  - Create a [github repo](https://github.com/stwalez/pbl_p19_t2) and input the downloaded module (main.tf file).
  - Add github repo to a new workspace
  - Trigger a plan to see that the module works
    ![](screenshots/task2_apply_module_plan.png)

- Deploy the infrastructure
  - Apply the plan
    ![](screenshots/task2_module_output.png)

  - View the webapp s3 bucket
    ![](screenshots/task_2_module_resources.png)

- Destroy your deployment

[Link to the PBL Github Repository](https://github.com/stwalez/PBL_p19)

[Back to top](#)