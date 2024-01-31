# Pocketbase

Bundles [Pocketbase](https://pocketbase.io/), [Caddy](https://caddyserver.com/) and [Supervisor](http://supervisord.org/index.html) in a single Docker image.

## Use the image from Dockerhub

> _NB. this is a `linux_arm64` only image; if you need a different architecture, see [below](#build-a-custom-image-from-source)._

```bash
docker pull altcmdio/pocketbase
```

## Build a custom image from source

```bash
git clone --depth 1 https://github.com/altcmdio/pocketbase.git
docker build --build-arg="PB_ARCH=linux_arm64" -t pocketbase .
# See `https://github.com/pocketbase/pocketbase/releases` for a list of available architectures.
# Defaults to `linux_arm64` if no `--build-arg` is specified.
```

## Files and locations

* The `pocketbase` directory is copied into the image at `/pb` - _you should mount a volume here (e.g. `-v ${PWD}/data:/pb`) if you want your Pocketbase data to be persistent._
* `supervisord.conf` is copied into the image at `/etc/supervisord.conf` and provides the basic configuration for Supervisor.
* `caddy.conf` is copied into the image at `/etc/supervisor.d/caddy.conf`, and configures how Supervisor will run Caddy.
* `pocketbase.conf` is copied into the image at `/etc/supervisor.d/pocketbase.conf` and configures how Supervisor will run Pocketbase.
* `Caddyfile` is copied into the image at `/etc/caddy/Caddyfile` and provides a simple reverse proxy configuration exposing Pocketbase.
* Pocketbase logs are written to `/var/log/pocketbase.log` - limited to a single logfile (`stdout` and `stderr`) with a maximum size of 1MB.
* Caddy logs are written to `/var/log/caddy.log` - limited to a single log file (`stdout` and `stderr`) with a maximum size of 1MB.

## Use it in your own projects

Use this image as a base in your own `Dockerfile`'s and override and/or add elements as required (`FROM altcmdio/pocketbase:latest`), or clone the repository and use it as boilerplate.

## Additional information

* Pocketbase [documentation](https://pocketbase.io/docs/)
* Caddy [documentation](https://caddyserver.com/docs/)
* Supervisor [documentation](http://supervisord.org/index.html)
