FROM docker/compose:alpine-1.27.4

ENV VERSION=2.0.2
ENV OS=linux
ENV ARCH=amd64

RUN wget -O - "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr > /usr/bin/docker-credential-gcr && chmod +x /usr/bin/docker-credential-gcr

RUN docker-credential-gcr version
RUN docker-credential-gcr configure-docker --include-artifact-registry
CMD docker-compose
