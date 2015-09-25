# VSFTPD Docker Image

This is a micro-service image for VSFTPD.

There are a few limitations but it will work if you are using host networking
`--net host` or have a direct/routed network between the Docker container and
the client.

## Virtual User

The FTP user has been set to uid 48 and gid 48.

## Options

The following environment variables are accepted.

- `FTP_USER`: Sets the default FTP user 

- `FTP_PASSWORD`: Plain text password, or

- `FTP_PASSWORD_HASH`: Sets the password for the user specified above. This
requires a hashed password such as the ones created with `mkpasswd -m sha-512`
which is in the _whois_ debian package.

## Usage Example

```
docker run --rm -it -p 21:21 -p 4559:4559 -p 4560:4560 -p 4561:4561 -p 4562:4562 -p 4563:4563 -p 4564:4564 -e FTP_USER=panubo -e FTP_PASSWORD=panubo panubo/vsftpd
```

## SSL Usage

SSL can be configured (non-SSL by default). Firstly the SSL certificate and key
need to be added to the image, either using volumes or baking it into an image.
Then specify the `vsftpd_ssl.conf` config file as the config vsftpd should use.

This example assumes the ssl cert and key are in the same file and are mounted
into the container read-only.

```
docker run --rm -it -e FTP_USER=panubo -e FTP_PASSWORD_HASH='$6$XWpu...DwK1' -v `pwd`/server.pem:/etc/ssl/certs/vsftpd.crt:ro -v `pwd`/server.pem:/etc/ssl/private/vsftpd.key:ro panubo/vsftpd vsftpd /etc/vsftpd_ssl.conf
```
