# inception# Inception — Dockerized WordPress Stack

## Description

**Inception** is a system administration project that aims to build a complete, secure, and containerized web infrastructure from scratch. The goal is to run three services—**NGINX**, **WordPress + PHP‑FPM**, and **MariaDB**—inside dedicated Docker containers, orchestrated by **Docker Compose**, all within a virtual machine. The only entry point is HTTPS on port 443, served by NGINX with TLSv1.2/TLSv1.3. Persistent data (database and WordPress files) is stored in Docker named volumes, mapped to the host’s `/home/armosnie/data/` directory.

The project enforces strict rules: no `:latest` tags, no pre‑built images (except base Debian/Alpine), no hacky infinite loops (`tail -f`, `sleep infinity`, etc.), and no hard‑coded secrets. All sensitive information must be passed via environment variables (`.env`) and, ideally, Docker secrets.

---

## Instructions

### Prerequisites
- A Linux virtual machine (Debian/Ubuntu recommended).
- Docker and Docker Compose installed.
- `git` to clone the repository.

### Installation & Launch
1. Clone the repository:
   ```bash
   git clone git@github.com:Jotarooo78/inception.git
   cd inception

Create the required host directories for persistent volumes:
bash

mkdir -p /home/armosnie/data/wordpress
mkdir -p /home/armosnie/data/mariadb

Set up the local domain name by adding the following line to /etc/hosts:
text

127.0.0.1  armosnie.42.fr

Place your environment variables in a .env file inside the srcs/ folder (see the provided example). Do not commit this file.

Build and start the entire stack with the Makefile:
bash

make up

    This command runs docker-compose up -d --build and ensures all services are built and started in detached mode.

    Access the website at https://armosnie.42.fr. Accept the self‑signed certificate warning.

Stopping & Cleaning

    Stop all containers: make down

    make prune to clean partitions and volumes

    after that sudo "rm -rf /home/armosnie/data/" with my password : Superman78

Resources

    Official documentation:

        Docker Compose

        NGINX

        MariaDB

        WordPress CLI

    Tutorials & articles:

        Docker’s best practices for writing Dockerfiles.

        Setting up PHP‑FPM and NGINX without a web server in the WordPress container.

        Managing PID 1 and avoiding zombie processes.

Use of AI:
Throughout the project, AI (specifically ChatGPT) was used to:

    Debug configuration files (nginx.conf, www.conf, MariaDB’s 50-server.cnf).

    Write and refine shell scripts for MariaDB and WordPress initialization.

    Understand networking and volume mapping in Docker Compose.

    Troubleshoot timing issues (MariaDB not ready before WordPress starts) and implement a robust mysqladmin ping loop.

All AI‑generated code was manually reviewed, tested, and adapted to fit the project’s constraints. Peer validation was also performed to ensure correctness and compliance with the subject.
Project Description & Design Choices
Why Docker?

Docker provides lightweight, isolated environments that simplify dependency management and guarantee consistency across different machines. Each service runs in its own container, making the stack modular, scalable, and easy to restart independently.
Architecture Overview
text

Internet (443) → NGINX container (TLS) → WordPress container (PHP‑FPM:9000) → MariaDB container (3306)
                  ↑                           ↑
         volume (wordpress)          volume (mariadb)

Comparison: Virtual Machines vs Docker

    Virtual Machines emulate entire hardware stacks, including a full operating system. They are heavy, slow to start, and consume significant resources.

    Docker containers share the host kernel and run as isolated processes. They are lightweight, start in milliseconds, and are ideal for microservices. This project uses Docker to minimize overhead and simplify orchestration.

Secrets vs Environment Variables

    Environment variables (.env file) are used to pass non‑sensitive configuration like domain name and database names. They are easy to inject into containers.

    Secrets (e.g., passwords, API keys) are more secure because they are not exposed in the container’s environment (they are mounted as files). For this project, we used .env for simplicity, but the subject strongly recommends Docker secrets for production. All passwords are excluded from Git via .gitignore.

Docker Network vs Host Network

    Host network (network: host) gives a container direct access to the host’s network stack, which is insecure and breaks isolation.

    Docker bridge networks provide a private, isolated network where containers can communicate using service names (e.g., mariadb:3306). This is the mandatory choice for Inception and ensures clean separation of services.

Docker Volumes vs Bind Mounts

    Bind mounts link a host directory directly into a container; they are host‑dependent and can lead to permission issues.

    Named volumes are managed by Docker and abstract the host storage. They are portable and recommended for persistent data. In this project, named volumes (wordpress, mariadb) are used and mapped to /home/armosnie/data/ on the host via the driver_opts in docker-compose.yml.

Step‑by‑Step Implementation Journey
1. Planning and Environment Setup

    Created the directory structure following the subject’s requirements (srcs/, requirements/, etc.).

    Set up the VM with Docker and Docker Compose.

    Added armosnie.42.fr to /etc/hosts.

2. Writing the MariaDB Container

    Dockerfile: Based on debian:bookworm, installed mariadb-server.

    Configuration: Modified 50-server.cnf to allow connections from any IP (bind_address = *).

    Initialization script: Started MariaDB, created the database and users from environment variables, then stopped the temporary instance and launched mysqld_safe as PID 1.

3. Writing the WordPress Container

    Dockerfile: Installed php-fpm, php-mysql, mariadb-client, and wp-cli.

    Downloaded and extracted WordPress.

    PHP‑FPM configuration: Set listen = wordpress:9000 and clear_env = no to propagate environment variables.

    Setup script: Used a loop with mysqladmin ping to wait for MariaDB to be ready, then used WP‑CLI to create wp-config.php, install WordPress, and create two users (an admin with a non‑obvious name and a standard author). Finally, launched php-fpm -F in the foreground.

4. Writing the NGINX Container

    Dockerfile: Installed NGINX, openssl, and generated a self‑signed certificate for TLS.

    Configuration: Used a custom nginx.conf that:

        Listens on 443 ssl.

        Enforces TLSv1.2/TLSv1.3.

        Serves files from /var/www/wordpress (shared volume).

        Forwards PHP requests to wordpress:9000.

5. Docker Compose and Volumes

    Defined three services in docker-compose.yml, each building its own Dockerfile.

    Created two named volumes (wordpress, mariadb) with driver_opts to bind them to /home/armosnie/data/.

    Set up a custom bridge network inception.

    Added restart: unless-stopped to all containers.

6. Makefile Automation

    Wrote a Makefile with targets: up, down, clean, fclean, re to simplify building and managing the stack.

7. Debugging and Fine‑Tuning

    Timing issue: WordPress initially failed to connect because MariaDB wasn’t ready. Replaced a simple sleep 5 with a mysqladmin ping loop.

    DNS resolution: The site wasn’t accessible because /etc/hosts lacked the domain entry. Added it manually.

    NGINX configuration: Initially placed the config in sites-available; moved it to conf.d to avoid confusion and ensure it was loaded.

8. Final Validation

    Tested all services with docker ps, docker logs, and curl -k https://armosnie.42.fr.

    Verified that both WordPress users exist and that the site loads correctly.

    Checked that volumes persist after container restarts.

Conclusion

Inception is a challenging but rewarding project that forces you to master Docker fundamentals, networking, process management, and security best practices. The step‑by‑step approach—starting with a single service and gradually adding layers—helped isolate issues and build a robust final stack. The result is a fully functional, production‑ready WordPress environment running inside containers, accessible only via a secure HTTPS connection.