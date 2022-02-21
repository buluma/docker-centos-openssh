# Docker Rocky Linux OpenSSH

A Rocky Linux container that runs openssh server.

![Maintenance](https://img.shields.io/maintenance/yes/2022) 
[![build-push](https://github.com/buluma/docker-centos-openssh/actions/workflows/build-push-action.yml/badge.svg)](https://github.com/buluma/docker-centos-openssh/actions/workflows/build-push-action.yml) 
![GitHub commits since tagged version](https://img.shields.io/github/commits-since/buluma/docker-centos-openssh/1.0.0/master) 
![Docker Pulls](https://img.shields.io/docker/pulls/buluma/docker-centos-openssh) 
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/buluma/docker-centos-openssh)

You can use this container to quickly startup a "machine" and test things, or it can be used as an SSH server, maybe a stepstone.

This container will generate new keys (host and user) at startup if none are loaded by attaching a volume.

## Running the container.

It's quite easy to start a container:

```bash
docker run -P buluma/docker-centos-openssh
```

For Podman, please use:

```bash
podman run --cap-add AUDIT_WRITE -P buluma/docker-centos-openssh
```

(The `--cap-add AUDIT_WRITE` is added to overcome an [issue](https://bugzilla.redhat.com/show_bug.cgi?id=1923728).)
    
A private key will be displayed, copy-pasts-save it, set the permissions to 0600.

Find out what port Docker has connected to the container:

```bash
docker port docker-centos-openssh
```

And connect to the container:

```bash
ssh -p ${port} -i ${savedkey} root@${ip}
```

The ${ip} depends on where the container is running.

## Using your own private key

Simply save your key in a folder like "dot-ssh" and map the volumes:

```bash
docker run -P -v $(pwd)/./ssh:/root/.ssh/ buluma/docker-centos-openssh
```

## Using with docker-compose

You may setup a testlab, for example for Ansible or Rundeck, using Docker-compose, like so:

```yaml
version: '3'
services:
  server:
    image: buluma/docker-centos-openssh
    volumes:
      - /path/to/dot-ssh:/root/.ssh/
    links:
      - client1
      - client2
      - client3
    ports:
      - "2222:22"
  client1:
    image: buluma/docker-centos-openssh
    volumes:
      - /path/to/dot-ssh:/root/.ssh/
  client2:
    image: buluma/docker-centos-openssh
    volumes:
      - /path/to/dot-ssh:/root/.ssh/
  client3:
    image: buluma/docker-centos-openssh
    volumes:
      - /path/to/dot-ssh:/root/.ssh/
```

# Technologies used to build and test

- [Docker Hub](https://hub.docker.com/r/buluma/docker-centos-openssh/) is used to deploy the image to.

Building on local and publishing to Docker Hub happens in parallel. On local environment, few project are used:

- [Docker Lint](https://github.com/projectatomic/dockerfile_lint) for finding weird errors.

A bit weird about this setup is that when the build fails, an image is still published.
