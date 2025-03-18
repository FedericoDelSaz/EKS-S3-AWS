# Use an official Nginx image as a base
FROM nginx:alpine

# Copy the image to the Nginx server's root directory
COPY image.jpg /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx server in the foreground
CMD ["nginx", "-g", "daemon off;"]