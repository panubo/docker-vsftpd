docker_tag 	= panubo/vsftpd

UNAME_S        := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    APP_HOST   := localhost
endif
ifeq ($(UNAME_S),Darwin)
    APP_HOST   := $(shell docker-machine ip default)
endif

build:
	docker build -t $(docker_tag) .

bash:
	docker run --rm -it $(docker_tag) bash

env:
	@echo "FTP_USER=ftp" >> env
	@echo "FTP_PASSWORD=ftp" >> env

run: env
	$(eval ID := $(shell docker run -d --env-file env -v $(shell pwd)/srv:/srv ${docker_tag}))
	$(eval IP := $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${ID}))
	@echo "Running ${ID} @ ftp://${IP}"
	@docker attach ${ID}
	@docker kill ${ID}
