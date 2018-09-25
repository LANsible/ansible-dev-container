### Regenerate client.crt and client.key

* Generate a client private key

`openssl genrsa -out client.key 4096`

* Generate a certificate request (csr)

`openssl req -new -key client.key -out client.csr`

* Generate an auto-sign certificate

`openssl x509 -req -days 3650 -in client.csr -signkey client.key -out client.crt`

### Setup local LXD for debug
`lxc remote add 127.0.0.1:8443`
`lxc remote set-default 127.0.0.1:8443`

openssl req -new -sha256 \
    -key server.key \
    -subj "/O=linuxcontainers.org/CN=root@ubuntu-desktop" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=DNS:ubuntu-desktop,IP:192.168.1.195,IP:172.17.0.1,IP:127.0.0.1")) \
    -out server.csr

# Debugging entrypoint
```
docker run -it -v $(pwd):/data/$(basename ~+) \
-v /var/snap/lxd/common/lxd/unix.socket:/var/lib/lxd/unix.socket \
-w /data/$(basename ~+) \
--entrypoint '' --user root \
lansible/ansible-dev-container:2.4 bash
```