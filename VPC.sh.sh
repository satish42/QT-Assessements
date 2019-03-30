     
#####create vpc 
  aws ec2 create-vpc --cidr-block 10.0.0.0/16
        id==="vpc-0dac2bb5f672c6c89",
#### create subnet 
  aws ec2 create-subnet --vpc-id vpc-0a32358f0ae08090a --cidr-block 10.0.0.0/24
       id==="subnet-02770e055f884a732",

 ###create internet gateway
   aws ec2 create-internet-gateway
        id ===="igw-0d28600edb2558f3c",
###attach igw to vpc
   aws ec2 attach-internet-gateway --internet-gateway-id igw-0d28600edb2558f3c --vpc-id vpc-0a32358f0ae08090a

 #####  create a route table in your vpc & add the route to internet gateway
         aws ec2 create-route-table --vpc-id vpc-0a32358f0ae08090a    
               "rtb-08266abba0fb8af24"
        aws ec2 create-route --route-table-id rtb-08266abba0fb8af24 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0d28600edb2558f3

                
######  attaching subnets to route tables (  subnet assosiation )
        aws ec2 associate-route-table --route-table-id rtb-08266abba0fb8af24 --subnet-id subnet-02770e055f884a732
             "AssociationId": "rtbassoc-02c23f99069738e25"

        
## create security group
        aws ec2 create-security-group --description "security group " --group-name secgrp --vpc-id vpc-0dac2bb5f672c6c89
                "GroupId": "sg-0b6d01fdd45b82366"
  ##adding ingress rules
aws ec2 authorize-security-group-ingress --group-id sg-0b6d01fdd45b82366 --protocol tcp --port 22 --cidr 0.0.0.0/0   
aws ec2 authorize-security-group-ingress --group-id sg-0b6d01fdd45b82366 --protocol tcp --port 88 --cidr 0.0.0.0/0 
  

 ## create ubuntu  with t2.micro in public subnet with secgrp security group
aws ec2 run-instances --image-id ami-08692d171e3cf02d6 --instance-type t2.micro --key-name apache --security-group-ids sg-0b6d01fdd45b82366 --subnet-id subnet-02770e055f884a732 --count 1 --associate-public-ip-address            
        "InstanceId": "i-090c5e42a8c33af32"
##showing our ec2 vm
aws ec2 describe-instances
  "PrivateIpAddress": "10.0.0.77"
  "PublicIp": "13.232.98.175"
  ssh -i oregon.pem ubuntu@13.232.93.175 
## create image 
aws ec2 create-image --instance-id i-090c5e42a8c33af32 --name myAMI
   "ImageId": "ami-0e9ff8f77b5313932"

 





