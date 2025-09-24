# Boilerplate for building a web application.
Next.js, Strapi, PostgreSQL, Nginx, Docker.

## Instruction 📖
- In the Docker folder, configure the environment.
- Start development and customize strapi.
- Add the resulting strapi token to the environment (it will be available on the frontend).
- On production, configure the nginx configuration for your domain. Also change the environment for production.
- Get ssl certificate using certbot for your server.

## Docker 🐳

#### Running containers for development
```
docker compose -f development.compose.yml --env-file .env.development up --build
```
or
```
./compose.sh development up --build
```

#### Running containers for production
```
docker compose -f production.compose.yml --env-file .env.production up -d --build
```
or
```
./compose.sh production up -d --build
```

#### Removing containers
```
docker compose -f *.compose.yml down
```
or
```
./compose.sh * down
```

## Strapi 🛠️
#### Data export without encryption and compression

```
npm run strapi export -- --no-encrypt --no-compress
```

#### Data import

```
npm run strapi import -- -f name_import_file.tar
```

## Certbot 🤖
#### Obtaining ssl certificate
```
docker compose -f production.compose.yml run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d [domain-name]
```