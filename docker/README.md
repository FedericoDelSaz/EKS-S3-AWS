# Render Image Docker Setup

This repository contains a `Dockerfile` that builds an image and serves it using Nginx. The goal is to build the Docker image and push it to the `felodel/render-image:latest` Docker repository.

## Prerequisites

Before you begin, make sure you have the following:

- Docker installed and running
- Access to the Docker registry (Docker Hub, or any other configured registry) with the appropriate permissions to push images
- `image.jpg` file placed in the same directory as the `Dockerfile`

## Steps

### 1. Build the Docker Image

Run the following command to build the Docker image:

```bash
docker build -t felodel/render-image:latest .
```

This will:

- Use the `Dockerfile` in the current directory
- Build an image tagged as `felodel/render-image:latest`

### 2. Verify the Image Build

After the build process is complete, you can verify that the image exists locally by running:

```bash
docker images
```

You should see `felodel/render-image` with the `latest` tag listed.

### 3. Push the Docker Image to the Registry

Push the image to the Docker registry using the following command:

```bash
docker push felodel/render-image:latest
```

You will be prompted to log in to Docker Hub if you haven't already. Once authenticated, the image will be pushed to the repository.

### 4. Run the Docker Container Locally

To run the container locally and serve the image:

```bash
docker run -d -p 8080:80 felodel/render-image:latest
```

This will start the container in detached mode and map port 8080 on your host to port 80 on the container.

### 5. Access the Image in Browser

Once the container is running, you can access the image by visiting:

```
http://localhost:8080/image.jpg
```