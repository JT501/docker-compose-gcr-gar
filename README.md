# `docker-compose` on Container Optimized OS (GCE) with access to GCR & GAR

Since GCE's [Container-Optimized OS](https://cloud.google.com/container-optimized-os) do not include `docker-compose` by default.
So, we need to use the official [docker/compose](https://hub.docker.com/r/docker/compose) image as a workaround.
However, `docker/compose` cannot access [GCR](https://cloud.google.com/container-registry) or [GAR](https://cloud.google.com/artifact-registry) to pull private images.
Therefore we have to create a custom docker-compose image which is authenticated to __GCR__ / __GAR__.

### 1. Create a file (i.e docker-compose-gar or whatever name)
`mkdir docker-compose-gar && cd docker-compose-gar`

### 2. Create a Dockerfile as follow 
```Dockerfile
FROM docker/compose:alpine-1.27.4

ENV VERSION=2.0.2
ENV OS=linux
ENV ARCH=amd64

# Install docker-credential-gcr
RUN wget -O - "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr > /usr/bin/docker-credential-gcr && chmod +x /usr/bin/docker-credential-gcr

RUN docker-credential-gcr version
RUN docker-credential-gcr configure-docker --include-artifact-registry
CMD docker-compose
```

### 3. Build docker-compose-gar image
`docker build -t docker-compose-gar .`

### 4. Add a `docker-compose` alias your shell configuration file, e.g. `.bashrc`
```bash 
echo alias docker-compose="'"'docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:$PWD" \
    -w="$PWD" \
    docker-compose-gar'"'" >> ~/.bashrc
```

### 5. Run `docker-compose`
Now you can pull the private images from GCR / GAR

Try:

`docker-compose pull`

or

`docker-compose up`

# Ref
- [Running Docker Compose with Docker](https://cloud.google.com/community/tutorials/docker-compose-on-container-optimized-os)
- [Setting up authentication for Docker](https://cloud.google.com/artifact-registry/docs/docker/authentication#standalone-helper)