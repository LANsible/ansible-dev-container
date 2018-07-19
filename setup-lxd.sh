#!/usr/bin/env bash
cat client.crt <<EOL
-----BEGIN CERTIFICATE-----
MIIFhDCCA2ygAwIBAgIQRlUrxzlxEGQVlKP4171PwDANBgkqhkiG9w0BAQsFADBA
MRwwGgYDVQQKExNsaW51eGNvbnRhaW5lcnMub3JnMSAwHgYDVQQDDBd3aWxtYXJk
b0BkZXNrdG9wLXVidW50dTAeFw0xODA3MTAxNzU1NTNaFw0yODA3MDcxNzU1NTNa
MEAxHDAaBgNVBAoTE2xpbnV4Y29udGFpbmVycy5vcmcxIDAeBgNVBAMMF3dpbG1h
cmRvQGRlc2t0b3AtdWJ1bnR1MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
AgEAx9MdrDkZUTUuNHXu/uZKn3le+VCGSkOMQSRpr895Igefw24W8KkKXFdTeZWb
hobTBY6BM6JSz5F/nkp0sqJp7a/yjdw1ttY6+LY4lWi0PkCFmG3cyouVlZSdoxSL
z0ZSDsbBzv/WyiakZeTcTmSHZBymsxm+pyh+d6efIsZUWec3SzwZDs95fFg1dhOf
aC0u0f7vuXUxpaEBWPl7BWn2908HH3WcnjWoX93e6mfdUGbEHqZm5vaz1re27UXm
cigk0eJOfH6OyYLdJyE2WV6KxD3I277GRSzVI1enbXlLmsYGmN2CMtSZ+RD2DsDk
qg8WlW3+A9HtgsXmrVCRDgIS2TS7df6Dd5h2cq2Alp0++zudZZXCRQojliY59rf8
3LLlAP3UERJ/ClfkPNic73XAYxuHLp6k1RFtWk94QvWeb/pE2jf/g2JOjuFLSwbC
dPXgFbFGpgtjaLoC38tK8bK7rnGVbqt/Yq5+IzFKAcT/GrbvJYYqIroXyxcyvXj7
qgoOxw7yLJ+a9dkKsOpurn3/vfsHihw98kPcMEOxTtFMfaezV2Z1fRw5juh5KtRT
2rtv35VZrY47UqgJn1knnTIhZPCtdZexPNKnmxafoV+SVieWjNy9wbF7zD6M6g0s
PuRuuj4d/ujUKAz1r2miG3wM3vAlPgO0hs+G5s99AWKQ7WMCAwEAAaN6MHgwDgYD
VR0PAQH/BAQDAgWgMBMGA1UdJQQMMAoGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAw
QwYDVR0RBDwwOoIOZGVza3RvcC11YnVudHWHBMCoAcOHBKwSAAGHBKwRAAGHBAo8
HgGHEP1CUFfdX4jRAAAAAAAAAAEwDQYJKoZIhvcNAQELBQADggIBAE71pwsmOyxB
toBB5ngNkdtDxoeH+iSfRaD1fhF6iGIIf4HbIKQrjoqjJDFlCxCaRiSgYGjNQHLZ
BHlimE1kV2C+mPKa0g94W4x4O20zvL8NX+qLHx4NJj1+VQO34AFznA4wGdqkN9P+
tFtD7rPXUE/8BwasErkANSQSZcIk5KSI1J3tc4wFq+HxoiKD3SGH0XSnsSoczC0j
1iKrcl1QV7tGh1bW2zmp/EcCBWKbDuXEzxD7B41EEQSmfbi51nGEWIu8Uxk9BO8E
TDMdJfhc753r/WCLqkyKTOAURGQlukzSlBtn6WA0MSxdkAfBiIG3pSnjfwqcK5k0
SxFz5eJqkYJTo6XYlh0erGAU90/UsTYcXBE0feMsa9YlEukjD/ysnF0X1gQyomnT
sgvzlH40YlJpBKgiuG16hRQnx2/ZylrYZH1f48m7EvdjQIa8MUO9LqAxLLI7FLco
jc2QJds5G/x0SQnnYqoLaWqXin/Gfg9aCbJrSPtucs7p0oytHq1EMoPQqrFj7amn
6Iltap5eOgAjZpRquhSIm8oaJfS+qxoOd56bj0GsttFRjPgMsOTAw5V3nJr9d5NW
hhVJN9sNJnKPHEzv2RLCr40to+9RR7WcDOSwckb8nFXdTGa8ULEwgb0WJTeMPMtr
/cR7kjEsvL1hcc22b2qYUZ6Z8cdyrkPd
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