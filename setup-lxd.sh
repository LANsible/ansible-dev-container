#!/usr/bin/env bash
cat client.crt <<EOL
-----BEGIN CERTIFICATE-----
MIIFBjCCAu4CCQDXua7rPsC5gDANBgkqhkiG9w0BAQsFADBFMQswCQYDVQQGEwJB
VTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0
cyBQdHkgTHRkMB4XDTE4MDcxOTIwNTI1MVoXDTI4MDcxNjIwNTI1MVowRTELMAkG
A1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0
IFdpZGdpdHMgUHR5IEx0ZDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
AL+9Ft63zczgrf2eVObl4M4mf2NI3BmB1vU2X80HLC3yYJYNd30f2kbXxbLrhnJL
R263oBNZ7uwkNEiE5EkHbK7LVfpPmWsqwy2RRP2UW4H1eZ8jDgK0k1KbElUp5ddK
u4CK1wmWJC1rgcZww0Keeb3UEaKmNsaBXZFaBet4VH9LhNvLMbbq7hiGIfR07I4s
cJ6H2thlPB/6Lv0YDH+AaYSDLpCs/sfpEYy8zxGe7Kgwu47MKsKrL2IQDWO/zUaD
qtZMSGnQoXmD5ssflrqbGJHvogAGaTCUygTBvXFy/vX14P7UkZzGLkWwkiQ1nyYc
j5yxkdhqi38NdSkJ3SooD7MYC68yDXJiOowo0WvusxHR2HPnopvCr8wr3rLsi3g3
jGG6IvVnWtZo7Ej2cKmlFXKIK29UnpX3z+IjJ0fpZFXIuul+znQJIIDavROESjaw
jt6mrZ+48jv60p/CnVp4jKnB7O2BbNtZDYqMIiihpaqzptE1yCWkg4Smdcn7rw/+
pFUij6hqHujUDA/lBeoOF729ML6Q6jQlCTgvXK+wlyywQVoSObd0WduEcy71cSKt
oIsubZlPWYCsmqZJZycQhPfnbQxH3SMaL5FXiw1O3Gz3bHYup8ug4BUUf86vFfZ9
qPACFGk/sjYT48JHqQEDWQse2QYsrtcQ7QkMqk19vgahAgMBAAEwDQYJKoZIhvcN
AQELBQADggIBAIFLj+JfLyxfuEFL8FdDGBnoMMn9ywjj6//Fx2j5elCTXZbijQS8
lQLTk/FaEVTj+XfscQ9bpRZdd3Hv3fHSoKpr/rLpkLxdNEiJDNTeBClWhLd6c9zN
NRqX959ZUtYKcm6U/5KNOK4cyXK/mcVvBCmxlC/W1GysCOwyQHs2tF/3wsMqrQ8u
dc/2AAKUJ8czo1kiAeIhoNvjdyTkWD5//+MRfHSy6Q2gMGxpaiJZPZ1ZQvWsQ/Cm
qX4CkVvUqNhAd85c+xQ+rv8YxVajtleNlf0hWiJTYbxYU8ZoeMUlzuE2mvDPIQgM
/XL2DhNwOD9fLUXpUnw7dVxOd+rqgUG563MVn9lB7txr91OKwC6guvO1y4NOz+/C
TArUsMcSCqfRSkDpd3bydT377gR09xroniLDQm4QyA2pBPEbFJvLWEvtdAzdE4vX
XjaCb8k3mdnpCU7gzxWej2GZPJAjQbp4V6XDEsqYeDqWwB2wu4Qn1XetEbmRLbSl
JfmzulhUDCXMlnD255n1E3kqmuh9pLzKP+hyCShdo19ZxEwgD0AursEifcxQ1LQr
0ic7mP/Fcpo3bI9ydRgqimsuaY70dJvy3EN0Ci1arsTJJEbgLWabOWLe2wpUxRoL
XD6Cj4PgA0L2p1MlXHqP9ttChG9sf5hRhV4AzzF7k6G8SgsnkAZ3fj/W
-----END CERTIFICATE-----
EOL

cat <<EOF | lxd init --preseed
config:
  core.https_address: '127.0.0.1:8443'
  core.trust_password: password
cluster: null
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  managed: false
  name: lxdbr0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: default
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
EOF

lxc config trust add client.crt
rm -f client.crt