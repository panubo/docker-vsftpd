NAME := panubo/vsftpd
TAG  := latest

build:
	docker build --build-arg FTP_UID=$(shell id -u) --build-arg FTP_GID=$(shell id -g) -t $(NAME):$(TAG) .

bash:
	docker run --rm -it $(NAME):$(TAG) bash

env:
	@echo "FTP_USER=ftp" >> env
	@echo "FTP_PASSWORD=ftp" >> env

vsftpd.pem:
	openssl req -new -newkey rsa:2048 -days 365 -nodes -sha256 -x509 -keyout vsftpd.pem -out vsftpd.pem -subj '/CN=self_signed'

run: env
	$(eval ID := $(shell docker run -d --env-file env -v $(shell pwd)/srv:/srv ${NAME}:${TAG}))
	$(eval IP := $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${ID}))
	@echo "Running ${ID} @ ftp://${IP}"
	@docker attach ${ID}
	@docker kill ${ID}

run-ssl: env vsftpd.pem
	$(eval ID := $(shell docker run -d --env-file env -v $(shell pwd)/srv:/srv -v $(PWD)/vsftpd.pem:/etc/ssl/certs/vsftpd.crt -v $(PWD)/vsftpd.pem:/etc/ssl/private/vsftpd.key ${NAME}:${TAG} vsftpd /etc/vsftpd_ssl.conf))
	$(eval IP := $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${ID}))
	@echo "Running ${ID} @ ftp://${IP}"
	@docker attach ${ID}
	@docker kill ${ID}
