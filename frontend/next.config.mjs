/** @type {import('next').NextConfig} */
const nextConfig = {
  env : {
    API_CONTAINER_URL: process.env.API_CONTAINER_URL,
    API_CLIENT_URL: process.env.API_CLIENT_URL,
    API_TOKEN: process.env.API_TOKEN,
  },
};

export default nextConfig;
