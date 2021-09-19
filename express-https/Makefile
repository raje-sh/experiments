gen-cert:
	@echo "Generate RSA Key"
	mkdir -p secret
	@openssl genrsa -out secret/privatekey.pem
	@echo "Generate Certificate"
	@openssl req -new -key secret/privatekey.pem -out secret/cert_unsigned.csr
	@echo "Sign the certificate"
	@openssl x509 -req -days 1 -in secret/cert_unsigned.csr -signkey secret/privatekey.pem -out secret/cert_signed.pem

