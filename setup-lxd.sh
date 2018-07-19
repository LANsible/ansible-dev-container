#!/usr/bin/env bash
cat client.crt <<EOL
-----BEGIN CERTIFICATE-----
MIIFdjCCA16gAwIBAgIQWcabTNlANVUfcqbA87S8uDANBgkqhkiG9w0BAQsFADA8
MRwwGgYDVQQKExNsaW51eGNvbnRhaW5lcnMub3JnMRwwGgYDVQQDDBNyb290QHVi
dW50dS1kZXNrdG9wMB4XDTE4MDcxOTE4MjIyNloXDTI4MDcxNjE4MjIyNlowPDEc
MBoGA1UEChMTbGludXhjb250YWluZXJzLm9yZzEcMBoGA1UEAwwTcm9vdEB1YnVu
dHUtZGVza3RvcDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANs//cUm
wmZOsGY4qveXFVOLkkjwOuUmKlN2WIlpu6J1ROGAi89P8Trgp1+SHLdVTbSdxUds
nPzAN/qr5/bU2M7j91HpUKgmOa0yLPvy+LphmR90lPa/N21Cp3R7QDlNUljBpAMy
ZDXxGMHvVk8SKbjQKog3XPuv42piY6c3v9nbR+XSFLb3ZfTg54s8rrTO7LcG660k
uwZoOn6REsjV4Pca9bqzBTd4haMST9QyjWfVCoH9GUPazPYdH0i8zSYaz7zbfQtd
xLamFpESXOqQJ1TFkyrduzRki636t+rsQb3mX3PwyNirAoZl8X9hEYfXC+F3E1KG
JHfdvqbGU0zyDOafrKMO9ny7Je1zwwq6q/uAQqxV4NjED6HfU3d+lVdEDkZ4rWjh
3YpcqL1KI7XtI3zQvhtI8wdsyuw9ii1rjANi2VtqQQi1KSC5iSv9IGw6RPlaL0qy
mKU9G+6LJgSoEFMYh1xWpYB3Bln32TFZUj6UeMMoUKUNJqGsxdb980Go5CtjrGzI
HKKns25g1vE7k1+RnZpnU5F7sNY6Wz+o8jb4uL06pbDs4UEF3gW0wRQfP9Fn2SoV
mNgEZt5OpsTJnwhSSyHmIfwR3zvYSHLrpBx8QfjiPxNiKv1gr428OMR/ht5z39pD
FHmHKOYeQR8WzcbAQcLXj9XbkInYwyGAIyBLAgMBAAGjdDByMA4GA1UdDwEB/wQE
AwIFoDATBgNVHSUEDDAKBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMD0GA1UdEQQ2
MDSCDnVidW50dS1kZXNrdG9whwTAqAHDhwQKn7YBhxD9QiicWNbtagAAAAAAAAAB
hwSsEQABMA0GCSqGSIb3DQEBCwUAA4ICAQBsSjNIj+oFYr4QPzqFpo65/5DB2vb/
dl/xv9/wv0VRZDFuJxmFh4rjQzcaaq7LuyUhMAD37cpq0zP2xZeE5cljTqFgFIH9
VcVbFNOQvQ9FYhCTQ9MYlLNkdUrK1VdHp9TGi9aQuMZ3mCBWft057vGBZK4XHq49
fi7efzPqNp+Ax0zMuvc5ebEkKvDWn1P3svN5bnm+e5Fq7cX0eb953UZHKGyF8Vpz
PYmI1tVy42STQJf66hfbycoFtMMMVBliZmNDJVugF5mqM0BRB1xczxMPghSzpZ+9
Nwt3d0Z/RkfPOa+U04FFQ4vChaEoeJKOi+5IXM+W+qePMdYNn7KyHZ9o7Qytb7xP
om5lcmLbZW326ddlzhhXIfIgesgHWCeO1nOmMGTZpE7VXX8ENNI5azRKPWrFBk+D
+0ShTpbXtwW5z5f83upKSGw88e0694GjMxXTym1z4ar0arf2703d9DOn3T1t+ZQK
g5c10j68mlxI6iYuTXUQNJPy5KG9OZxTL0sQ72yhXsMVcCRKDkZM7vCpttrj60SH
2KTT1pXzWwiCYxrYTza4H7K3vN1vZz1MyNKOtDX7G3rtdLLNOIJqpHzyYVxiUMfg
nDcRsnkLml9R5vcMy+HWMTVAP/6Y8UI1N/jv0xmNrDIAG7hWKXQDIcB6pTsWJIuH
t82yGYfwSVH+Sw==
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