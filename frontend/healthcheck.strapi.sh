#!/bin/sh

echo "Waiting for Strapi to be ready..."

until curl -s http://strapi:1337/_health > /dev/null; do
  echo "Strapi is not ready yet. Retrying in 5 seconds..."
  sleep 5
done

echo "Strapi is ready. Starting build process."
yarn build || { echo "Build failed!"; exit 1; }

echo "Build completed. Starting the application."

pm2-runtime start "yarn start" --name api || { echo "Application failed to start!"; exit 1; }