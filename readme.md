## docs

- [Medium 1](https://medium.com/@ksh.ludhwani/setup-hashicorp-vault-using-docker-825b3e11ad2b)
- [Medium 2](https://medium.com/curious-devs-corner/running-hashicorp-vault-locally-f27f291157bf)

## create local certs

Using OpenSSL (available on Windows via Git Bash, WSL, or standalone install):

**1. Generate the CA key and certificate:**

```bash
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/CN=Vault CA" \
  -out ca.crt
```

**2. Generate the Vault server key and CSR:**

```bash
openssl genrsa -out vault.key 4096
openssl req -new -key vault.key \
  -subj "/CN=vault.test.lan" \
  -out vault.csr
```

**3. Create a SAN extension file (`vault-ext.cnf`):**

```ini
[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = vault.test.lan
DNS.2 = localhost
IP.1  = 127.0.0.1
```

**4. Sign the Vault certificate with the CA:**

```bash
openssl x509 -req -in vault.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out vault.crt -days 825 -sha256 \
  -extfile vault-ext.cnf -extensions req_ext
```

**Verify:**

```bash
openssl verify -CAfile ca.crt vault.crt
openssl x509 -in vault.crt -text -noout | grep -A2 "Subject Alternative"
```

Place the three files (`ca.crt`, `vault.crt`, `vault.key`) into the directory mounted at `/vault/userconfig/tls/` in your Docker setup. Make sure `vault.key` has restrictive permissions (`chmod 600 vault.key` on Linux/WSL).
