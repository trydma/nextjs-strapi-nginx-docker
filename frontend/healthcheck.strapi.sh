#!/bin/sh

# if the script is not defined in the container, change CRLF to LF.

echo "Waiting for Strapi to be ready..."

until curl -s http://strapi:1337/_health > /dev/null; do
  echo "Strapi is not ready yet. Retrying in 5 seconds..."
  sleep 5
done

echo "Strapi is ready. Starting build process."
pnpm build || { echo "Build failed!"; exit 1; }

echo "Build completed. Starting the application."

exec pnpm start || { echo "Application failed to start!"; exit 1; }