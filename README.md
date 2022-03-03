# tera-webapp

Deploying a Hello World web application.

## Webapp

The Hello World application is a simple web application written in Flask. The word 'World' can be updated dynamically. This application has two APIs (GET and POST) to get and set the word. 

This implementation uses Redis to store/retrieve the value. There are many ways to achieve this such as using a global variable or writing to a temporary file. I implemented this way to show the interaction between two services. When the project grows bigger, it will be more manageable to split into microservices for scalability.

- GET: This API call will retrieve the current value (default: World)
- POST: This API call will set a new value (default: World)

#### Updating the Word

To update the word and retrieve the value, run the following in Python:

```python
import requests
requests.post("http://127.0.0.1:5000/hello", data="tera-webapp")

r = requests.get("http://127.0.0.1:5000/hello")
r.text # this will return tera-webapp
```

Refresh the page and it will render 'Hello tera-webapp!'

---

## Infrastructure

### Cloud native container registry

Tools:

- Amazon Elastic Container Registry
- Terraform

I created a script using Terraform to create an Amazon Elastic Container Registry. The container registry will store the hello world docker image.

The script is in `terraform/ecr`

For this example, I created an IAM user with all the permissions to be able to push the container into the registry. In a production environment, security is very important and will require locking down the permission to be less opened. If I had the proper time, the account should be limited to only able to write the image into the registry.

### 4 instances with different OS + network

Tools:

- AWS EC2
- Terraform

The script is in `terraform/deploy`

The `variables.tf` file contains 4 different OS. I created a mapping variable that loops through each property and set the corresponding attributes. This makes it cleaner and easier to manage the code. Adding more OS or scaling more resources will be simple. In this example, the network configuration is very basic. One vpc, public subnet + security group (SSH, HTTP, HTTPS and RDP ports). Depending on the use case of the application, introducing private subnets, security groups and load balancers can improve the security and scalability to handle traffic. Also, this example doesn't use an elastic IP which can be useful for deploying a static IP.

## Integration + Publish

Tools:

- pytest
- github
- github actions

For continuous integration, I used Github Actions for the workflow. I configured it to trigger on push to the remote repository in Github. It will run docker-compose to build the docker image of the web application, validate using pytest and if it is successful, push the final image to the container registry. Currently it pushes to the container registry every single push that is a feature or main or pull request. This also workflow lacks version control.

If I have more time, I would change the workflow to build and test for every branch but not push the final container unless it's a release/tag. For a proper release cycle, it makes more sense to only publish the final image to the container registry.

## Deployment

For this application, I would deploy this using a container orchestration. Since this is a web application, scalability is important. The amount of traffic going to the web application can affect the stability. Things like vertical and horizontal scaling should be taken into account. In my example, I didn't use a load balancer either which can help distribute the work.

I will setup different environments such as development and production, etc... to validate the different stages to make sure no glaring issues affecting usability slips through. Also, to make sure there is rollback in place incase something unfortunately happens that can break after deployment.

Fail fast, fix fast!

### Bonus

Tools:

- AWS Elastic Container Service
- Terraform

The script is in `terraform/ecs`

Unfortunately the script I created doesn't completely work, I wasn't able to finish on time. I researched the different services that Amazon provided for deployment:

1. ECS + EC2
2. ECS + Fargate
3. EKS
4. AWS Kops

The example I created uses ECS + EC2. There are pros and cons to each choice. I was curious and wanted to try out ECS + EC2. The advantage of this choice is that it is customizable allowing more flexibility to tinker to the desire result. The disadvantage is that it requires self management. For example if there is a vulnerability like log4j, the EC2 instance will require user to fix (for each instance deployed). If I have more time, I would experiment with ECS + Fargate. For Fargate, all those mundate things are abstracted away such as managing the servers and patching security vulnerabilities. 

The issue I ran into with ECS + EC2 is that the EC2 deployment requires an ECS agent (which communicates to the ECS cluster). I wasn't able to get the ECS agent to run properly. Amazon does offer ECS optimized AMIs which should alleviate the trouble of setting up.

---

References

- terraform AWS [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)[1]
- AWS ECR [documentation](https://docs.aws.amazon.com/ecr/)[2]
- ECR [example](https://github.com/lgallard/terraform-aws-ecr)[3]
- AWS ECS [documentation](https://docs.aws.amazon.com/ecs/index.html)[4]
- ECS [example](https://medium.com/swlh/creating-an-aws-ecs-cluster-of-ec2-instances-with-terraform-85a10b5cfbe3)[5]
