# tera-webapp

Deploying a Hello World web application (flask) using AWS suite.

## Hello World (Flask)

The Hello World application is a simple web application written in Flask. The word 'World' can be updated dynamically. This application has two APIs (GET and POST) to get and set the word. 

This implementation uses Redis to store/retrieve the value. There are many ways to achieve this without Redis such as using a global variable or writing to a temporary file for this particular case. The reason I implemented this way is to show the interaction between multiple services and how it can be expanded on if the project grows bigger.

- GET
- POST

### GET

This API call will retrieve the current value (default: World)

### POST

This API call will set a new value to (default: World)

## Usage

This is a step-by-step guide on how to build and run the application.

Pre-requisites:

- Docker installed
- Linux machine

### Building the Docker Image

```bash
docker-compose build
docker-compose up
```

This will start on localhost:5000.

### Updating the Word

To update the word and retrieve the value, run the following:

```python
import requests
requests.post("http://127.0.0.1:5000/hello", data="tera-webapp")

r = requests.get("http://127.0.0.1:5000/hello")
r.text # this will return tera-webapp
```

Refresh the page and it will render 'Hello tera-webapp!'

---

## CI/CD

In this example, this repository uses Github Actions to trigger a chain of events from building, testing and pushing the container to a cloud native registry.

The current workflow is defined in the `workflow.yml` file.

### Integration

The tools used:

- docker-compose
- pytest
- AWS Elastic Container Registry
- terraform

docker-compose: used to build the web application\
pytest: used to test the web application REST api calls\
AWS ECR: docker registry to push the final image of the web application\
terraform: used to setup the infrastructure

The terraform script under the `terraform/ecr` folder contains the necessary infrastructure to configure the integration portion. 

#### Usage

```bash
cd terraform/ecr
terraform init
terraform apply
```

This will create an AWS ECR docker registry in AWS and the necessary outputs to setup the secrets to integrate with Github and Github Actions.

### Deployment

WIP

---

References

terraform AWS documentation(https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

AWS ECR documentation(https://aws.amazon.com/ecr/)

ECR example(https://github.com/lgallard/terraform-aws-ecr)
