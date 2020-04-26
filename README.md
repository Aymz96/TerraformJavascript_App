# Terraform  :computer: :cd:

This repository will display how to use this project from an engineering point of view.

- The project consists of a main.tf file which runs the main code for the terraform and variables.tf file which is used to create variables and call them in the main.tf file.

- In the NodeSampleApp_tf repo theres a packer.json file which has been used to develop an AMI in order to launch the AWS instance.

### Prerequisites
- In order to run the NodeSampleApp_tf on the EC2 cloud you must ensure you have the following below:

```CSS
- AMI
- AWS Cli
- Terraform
- AWS Credentials
- pem key
- Git
- (http://yourip)
- Atom
```

### What is Terraform?
- Terraform is an Orchestration tool which part of the infrastructure as code.

- In comparison to Chef and packer where these are referred to more of a configuration management side and create immutable AMI's

- Terraform sits on the Orchestration side. This includes the creation of networks and complex systems to deploy AMI's

- An AMI is a blue print of an instance.
  - The operating system
  - Data and storage
  - All the packages and exact state of a machine when AMI was created.

- - If you haven't already, please go to the NodeSampleApp_tf repository follow the steps before continuing to Terraform or clone the repo from here:
git clone git@github.com:Aymz96/NodeSampleApp_tf.git

### Setup Terraform to run the app
- The main.tf and variables.tf needs to be configured to create an EC2 using an AMI and VPC which adds security to the cloud instance, as done in this repository.

- Once this has been done, locate into the first_terraform directory and run the command below:
```python
terraform plan
```
- The terraform plan command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

- If `terraform plan` is successful run the next command below:
```python
terraform apply
```
- The terraform apply command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan. In this case it will create a new EC2 machine using the AMI-ID which has been coded into the variables.tf file.

- The Terminal will continue to run in this case after it has successfully created the EC2 as the app will be listening to port 3000.
```python
aws_instance.app_instance: Still creating... [10s elapsed]
```
### Testing App in the cloud
- Now you must test if the App is running. Open a new web browser and enter your EC2 `IPv4 Public IP`. The App will display. Then enter `IPv4 Public IP/fibonacci/5` to view the fibonacci generator; Success.

- If you have chosen to create this project from scratch, you will need to run the command below before `terraform plan` & `terraform apply` as this create your Terraform files.
```python
terraform init
```
- The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

#### Author
**Ayman Yousfi** - *Junior DevOps Engineer* - [Aymz96](https://github.com/Aymz96)
