# prodious_assesment
Contains Terraform script
Here i have user HCL language to create the infracture. I have used two files one is the main file which contains all the configuration details and the other one is variable file,  where i have secret key and access kay. In the real time adding the secret ket and access key in variable file is not recomonded. In that place we can use EXPORT command to set the invoroment variable in our shell. To do it in permanent basis we can add it in the ~/.bashrc file. I have given the default region as ap-south1. if user will not give any region in runtime it will create a resouce under ap-south1.
command to run:
terraform init 
terraform plan
terraforn apply -vars="region=us-east1" -vars="syedbucket23" -var-file=variables.tfvars
