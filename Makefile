DOCKER_PROVIDER = "REGISTRY_PROVIDER_URL" 
DOCKER_REGISTRY = $(DOCKER_PROVIDER)
DOCKER_TAG = latest
DOCKER_IMAGE = my-first-ecr-repo


docker-build:
	@echo copy resources
	docker build --platform linux/amd64 --build-arg DOCKER_TAG='$(GIT_DESCR)' -t $(DOCKER_IMAGE)  .
	@echo done
	
docker-login:
	# docker login $(DOCKER_PROVIDER)
	aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $(DOCKER_REGISTRY)

docker-push: docker-login
	@echo push image
	docker login $(DOCKER_PROVIDER)
	docker tag $(DOCKER_IMAGE):latest $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	$(eval DOCKER_TAG = latest)
	docker tag $(DOCKER_IMAGE):latest $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo done