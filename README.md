# SSL Hello World - Intermediate Certificate

This branch introduces you to intermediate certificates.

This project is a small demonstration of how to setup SSL on Nginx. The purpose of this is not to demonstrate
any best practices. It's just to give a you something to help get used to SSL.

## How to use

First create an SSL certificate for the domain server.example.com:

```bash
openssl req -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr -config server.conf
openssl req -newkey rsa:2048 -nodes -keyout int.key -out int.csr -config int.conf
openssl req -x509 -days 1825 -extensions v3_ca -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt -config ca.conf
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in int.csr -out int.crt -days 365 -CAcreateserial -extfile ./openssl.cnf -sha256 -extensions v3_intermediate_ca -set_serial 01
openssl x509 -req -CA int.crt -CAkey int.key -in domain.csr -out domain.crt -days 365 -CAcreateserial -extfile domain.ext -set_serial 02 -sha256
```

Now you can start the webserver with `docker-compose up`, which will be exposed on port 8900.

Test the webserver is up

```bash
curl https://localhost:8900
```

You will get an error because the CA certificate that you used to create your certificate
is not trusted by your system.

```bash
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

Amend the curl command to trust the root CA certificate

```bash
curl https://localhost:8900 --cacert rootCA.crt
```

This still fails because the domain localhost isn't in the certificate presented by Nginx.

```bash
curl: (60) SSL: no alternative certificate subject name matches target host name 'localhost'
```

Have a look at the certificate

```bash
openssl x509 -in domain.crt -noout -text
```

In the `Subject` field of the output the `CN` or Common Name is server.example.com. Part of the SSL handshake
is to check if the domain matches the CN in the certificate. Other valid domains for this certificate
can be found in the `X509v3 Subject Alternative Name` field.

Add an entry to your hosts file

```bash
127.0.0.1 server.example.com
```

Amend the curl command to use the domain server.example.com.

```bash
curl https://server.example.com:8900 --cacert rootCA.crt
```

You will now see the server response which is the contents of `index.html`. This
connection is secured with SSL !