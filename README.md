# inception

Mise en place d'une infrastructure Docker multi-services avec Docker Compose. Projet de l'école 42 orienté administration système, isolation des services et bonnes pratiques de déploiement.

## Objectif
Construire un environnement de services conteneurisés, interconnectés via un réseau Docker, avec persistance des données, variables d'environnement et démarrage orchestré.

## Services (architecture classique du projet)
- NGINX avec TLS (point d'entrée HTTPS)
- WordPress (PHP-FPM)
- MariaDB (base de données)
- Volumes persistants pour les données applicatives
- Réseau Docker dédié entre services

## Notions abordées
- Création d'images Docker personnalisées (Dockerfile)
- Orchestration avec Docker Compose
- Gestion des secrets et variables d'environnement (`.env`)
- Reverse proxy et terminaison TLS
- Isolation réseau et communication inter-conteneurs
- Persistance via volumes
- Gestion du cycle de vie des conteneurs (build, up, down, logs)

## Stack
Docker, Docker Compose, NGINX, WordPress, MariaDB, Linux

## Installation et lancement
```bash
git clone git@github.com:Jotarooo78/inception.git
cd inception
make
```

Selon ton Makefile, le lancement peut appeler `docker compose up --build` automatiquement.

## Commandes utiles
```bash
# démarrer les services
docker compose up -d --build

# voir les logs
docker compose logs -f

# arrêter les services
docker compose down

# arrêter et supprimer aussi les volumes (attention: perte de données)
docker compose down -v
```

## Structure attendue
- `srcs/docker-compose.yml` : orchestration des services
- `srcs/requirements/` : Dockerfiles et configurations par service
- `.env` : variables d'environnement (non versionnées)

## Points recruteur
- Infrastructure reproductible en une commande
- Cloisonnement propre des services
- Configuration réseau/volumes claire
- Approche orientée déploiement et exploitation
