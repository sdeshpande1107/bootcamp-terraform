#Terraform bootcamp Nodejs weight tracker project using azure virtual scale set#

This branch will help you get an idea about the terraform modules to create various resources in azure using terraform.

The branch includes tf files to create resources such as :

1. Loadbalancer
2. Virtual network
3. Virtual machines in scale set for applicationa and a separate vm for database
4. Outputs
5. Variables
6. State storage in azure storage account
7. security groups 

In order to create a specific resource, copy the code of that resource and save it with ".tf" extension. 

################ To initialize terraform state file ###################

terraform init

################ To check what resources will be created ###############

terraform plan

################ To perform resource creation process ##################

terraform apply

############### To destroy created resources ###########################

terraform destroy


