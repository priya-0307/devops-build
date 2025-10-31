# Use nginx to serve the built files
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy the prebuilt React files
COPY dist/ .


EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
