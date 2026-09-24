# filelisting

Apache-based file browser as a Docker container.

Imagine you want to expose a specific directory to the public, but you don't want to setup some complicated service (e.g., Nextcloud) or send around links to wetransfer.com, then this is for you.

Use cases:
* You are using Syncthing which syncs files (like Nextcloud), but unlike Nextcloud, there is no web interface to browse the files.
* You want to offer some files to other people, but don't want to use wetransfer.com et al.

You can optionally password-protect your files via Apache's htaccess/htpasswd mechanism.

## Prerequisites

- Docker
- `htpasswd` (package `apache2-utils`) – only if you want to password-protect your files

## Directory structure

You need to have your files somewhere, e.g.:
```
/home/myuser/files/
```

If you want to password-protect your files, additionally have something like:
```
/home/myuser/services/filelisting/
├── .htaccess
└── .htpasswd
```

## Setup

If you don't need password protection there is nothing to set up.

### Password protection

1. Create `.htaccess`
```bash
cat <<EOF > /home/myuser/services/filelisting/.htaccess
AuthType Basic
AuthName "Files"
AuthUserFile /data/.htpasswd
Require valid-user
EOF
```

2. Create `.htpasswd`
```bash
touch /home/myuser/services/filelisting/.htpasswd
htpasswd /home/myuser/services/filelisting/.htpasswd myuser
```

## Run the container

Note: The last 2 `-v` parameters to mount the volumes with .htaccess and .htpasswd are required only when you want to password-protect your files. Omit them if you want to skip password protection.

`.htaccess` and `.htpasswd` are only present inside the container at `/data` —  
the directory `/home/myuser/files` is not polluted with them.

```bash
docker run -d -p 80:80 \
  -v /home/myuser/files:/data \
  -v /home/myuser/services/filelisting/.htaccess:/data/.htaccess:ro" \
  -v /home/myuser/services/filelisting/.htpasswd:/data/.htpasswd:ro" \
  dockerhub.io/tobiaszieger/filelisting:1.0.0
```

