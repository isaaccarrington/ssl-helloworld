# SSL Hello World

This project is a small demonstration of how to setup SSL.

openssl req -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr -config csr.conf
openssl req -x509 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt -config ca.conf
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 365 -CAcreateserial -extfile domain.ext -sha256
openssl x509 -text -noout -in domain.crt