# Boilerplate for building a web application.
Next.js, Strapi, PostgreSQL, Nginx, Docker.

## Instruction 📖
- In the Docker folder, configure the environment.
- Start development and customize strapi.
- Add the resulting strapi token to the environment (it will be available on the frontend).
- On production, configure the nginx configuration for your domain. Also change the environment for production.
- Get ssl certificate using certbot for your server.

## Docker 🐳

#### Running containers for development:
```
cd docker

docker compose -f development.compose.yml --env-file .env.development up --build
```
or
```
./docker/compose.sh development up --build
```

#### Running containers for production:
```
cd docker

docker compose -f production.compose.yml --env-file .env.production up -d --build
```
or
```
./docker/compose.sh production up -d --build
```

#### Removing containers:
```
cd docker

docker compose -f *.compose.yml down
```
or
```
./docker/compose.sh * down
```

#### Running a scheduled docker cleanup script:
```
./scripts/setup-docker-cleanup-cron.sh
```

#### Running a docker cleanup script:
```
./scripts/docker-cleanup.sh
```

## Strapi 🛠️
#### Data export without encryption and compression:
*Local*
```
pnpm run strapi export --no-encrypt --no-compress -f export-data
```

*Development*
```
./scripts/export-strapi-development.sh containerId?
```

*Production*
```
./scripts/export-strapi-production.sh user@host containerId?
```

#### Data import:
*Local*
```
pnpm run strapi import -f export-data.tar
```

*Development*
```
./scripts/import-strapi-development.sh containerId?
```

*Production*
```
./scripts/import-strapi-production.sh user@host containerId?
```

## Certbot 🤖
#### Obtaining ssl certificate:
```
docker compose -f production.compose.yml run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d [domain-name]
```

#### Setting up automatic certificate renewal:
```
./scripts/setup-certbot-cron.sh
```

#### Manual certificate renewal:
```
./scripts/renew-certbot.sh
```
