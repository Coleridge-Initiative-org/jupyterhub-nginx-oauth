include ./makefiles/variables.mk
REPO_NAME  ?= adrf-jupyterhub-nginx-oauth

# Login in Aws Ecr of Dev Env
login-dev:
	aws ecr get-login --no-include-email --region us-east-1 | sh

# Login in Aws Ecr of Stg Env
login-stg:
	aws ecr get-login --no-include-email --region us-gov-west-1 | sh

# Login in Aws Ecr of Prod Env
login-prod:
	aws ecr get-login --no-include-email --region us-gov-west-1 | sh

# Build the docker image 
build: 
	docker build -t $(REPO_NAME):$(FULLTAG) .

# Genatera tag 
tag: build
	docker tag $(REPO_NAME):$(FULLTAG) $(AWS_ECR)/$(REPO_NAME):$(FULLTAG)

# Push image to Aws Ecr in Dev
push: login-dev tag
	docker push $(AWS_ECR)/$(REPO_NAME):$(FULLTAG)

# Genarate tag to Staging Env
tag-stg:
	docker tag $(REPO_NAME):$(FULLTAG) $(AWS_ECR_STG)/$(REPO_NAME):$(FULLTAG)

# Push to Staging
push-stg: login-stg tag-stg
	docker push $(AWS_ECR_STG)/$(REPO_NAME):$(FULLTAG)

# Genarate tag to Production Env
tag-prod:
	docker tag $(REPO_NAME):$(FULLTAG) $(AWS_ECR_PROD)/$(REPO_NAME):$(FULLTAG)

# Push to Production
push-prod: push-prod tag-prod
	docker push $(AWS_ECR_PROD)/$(REPO_NAME):$(FULLTAG)