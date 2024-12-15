#!/bin/sh

echo "Waiting for Frontend to be ready..."

until curl -s http://frontend:3000 > /dev/null; do
  echo "Frontend is not ready yet. Retrying in 5 seconds..."
  sleep 5
done

echo "Frontend is ready. Starting Nginx..."

exec nginx -g "daemon off;"