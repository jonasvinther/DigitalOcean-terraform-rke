.PHONY: tf-up rke-up

RKE := rke
TERRAFORM := terraform

tf-up:
	#terraform -auto-approve apply
	$(TERRAFORM) apply ./terraform

tf-down:
	$(TERRAFORM) destroy ./terraform

rke-up:
	$(RKE) up --config cluster.yml