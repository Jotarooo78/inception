NAME = inception
SECRETS_DIR = secrets

secrets:
	@mkdir -p $(SECRETS_DIR)
	@[ -f $(SECRETS_DIR)/db_password.txt ]      || openssl rand -base64 16 > $(SECRETS_DIR)/db_password.txt
	@[ -f $(SECRETS_DIR)/db_root_password.txt ] || openssl rand -base64 16 > $(SECRETS_DIR)/db_root_password.txt
	@[ -f $(SECRETS_DIR)/wp_admin_password.txt ]|| openssl rand -base64 16 > $(SECRETS_DIR)/wp_admin_password.txt
	@[ -f $(SECRETS_DIR)/wp_user_password.txt ] || openssl rand -base64 16 > $(SECRETS_DIR)/wp_user_password.txt

up: secrets
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker-compose -f srcs/docker-compose.yml up -d --build

down:
	@docker-compose -f srcs/docker-compose.yml down

prune:
	@docker system prune -af

.PHONY: up down prune