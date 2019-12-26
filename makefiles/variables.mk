TAG   ?= 1
FULLTAG = $(shell date +secure-%Y%m%d-v)$(TAG)
AWS_ECR   ?= 441870321480.dkr.ecr.us-east-1.amazonaws.com
AWS_ECR_STG  ?= 774391758379.dkr.ecr.us-gov-west-1.amazonaws.com
AWS_ECR_PROD ?= 233706244364.dkr.ecr.us-gov-west-1.amazonaws.com
