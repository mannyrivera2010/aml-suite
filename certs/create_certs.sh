#!/usr/bin/env bash
# Script used to create Certificates
# based on http://nategood.com/client-side-certificate-authentication-in-ngi
# https://gist.github.com/Soarez/9688998

rm *.key *.txt *.pem *.crt *.csr -f

CA_SIGNED_CERT='ca_root'
CA_KEY_FILENAME=$CA_SIGNED_CERT.key
CA_SIGNED_CERT_FILENAME=$CA_SIGNED_CERT.crt
CA_SUBJ='/C=US/ST=MD/L=Baltimore/O=AML Demo CA/OU=Domain Control/CN=Demo ALM Root CA/emailAddress=admin@aml.com'
CA_PASSWORD_FILE='ca_passphrase.txt'

SERVER_KEY='server.key'
SERVER_REQUEST='server.csr'
SERVER_SIGNED_CERT='server.crt'

SERVER_NOPASS_KEY='server_nopass.key'
SERVER_NOPASS_REQUEST='server_nopass.csr'
SERVER_SIGNED_NOPASS_CERT='server_nopass.crt'

SERVER_SUBJ='/C=US/ST=MD/L=Baltimore/O=AML Server/OU=Domain Control/CN=localhost/emailAddress=admin@aml.com'
SERVER_PASSWORD_FILE='SERVER_passphrase.txt'

CREATE_CA_ROOT_CERT(){
  # Create the CA Key and Certificate for signing Client Certs
  openssl rand -base64 48 > $CA_PASSWORD_FILE
  openssl genrsa -des3 -passout file:$CA_PASSWORD_FILE -out $CA_KEY_FILENAME 4096
  openssl req -new -passin file:$CA_PASSWORD_FILE -x509 -days 365 -key $CA_KEY_FILENAME  -subj "$CA_SUBJ" -out $CA_SIGNED_CERT_FILENAME
  openssl x509 -in $CA_SIGNED_CERT_FILENAME -out $CA_SIGNED_CERT.pem  -outform PEM
}

CREATE_SERVER_CERT(){
  # Create the Server Key, CSR, and Certificate
  # We're self signing our own server cert here.  This is a no-no in production.
  # TODO: Serial 00 B8 FB C1 B7 85 33 54 28
  echo 'password1!' > $SERVER_PASSWORD_FILE
  openssl genrsa -des3 -passout file:$SERVER_PASSWORD_FILE -out $SERVER_KEY 2048
  openssl req -new -passin file:$SERVER_PASSWORD_FILE -key $SERVER_KEY -subj "$SERVER_SUBJ" -out $SERVER_REQUEST
  openssl x509 -req -days 365 -in $SERVER_REQUEST -passin file:$CA_PASSWORD_FILE -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $SERVER_SIGNED_CERT

  # Create the Server Key, CSR, and Certificate used for apache or ngnix servers
  # We're self signing our own server cert here.  This is a no-no in production.
  openssl genrsa -out $SERVER_NOPASS_KEY 2048
  openssl req -new -nodes -key $SERVER_NOPASS_KEY -subj "$SERVER_SUBJ" -out $SERVER_NOPASS_REQUEST
  openssl x509 -req -days 365 -in $SERVER_NOPASS_REQUEST -passin file:$CA_PASSWORD_FILE -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $SERVER_SIGNED_NOPASS_CERT
}

CREATE_CLIENT_CERT(){
  # Create the Client Key and CSR
  # We're self signing our own server cert here.  This is a no-no in production.
  # TODO: Serial 00 B8 FB C1 B7 85 33 54 28
  openssl genrsa -des3 -passout file:$SERVER_PASSWORD_FILE -out $CURRENT_USER_FILENAME.key 2048
  openssl rsa -in $CURRENT_USER_FILENAME.key -passin file:$SERVER_PASSWORD_FILE -out bigbrother_nopassword.pem

  openssl req -new -passin file:$SERVER_PASSWORD_FILE -key $CURRENT_USER_FILENAME.key -subj "$CURRENT_USER_SUBJ" -out $CURRENT_USER_FILENAME.csr
  openssl x509 -req -days 365 -in $CURRENT_USER_FILENAME.csr -passin file:$CA_PASSWORD_FILE -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $CURRENT_USER_FILENAME.crt

  openssl pkcs12 -export -passin file:$SERVER_PASSWORD_FILE -password pass:password -out $CURRENT_USER_FILENAME.p12 -inkey $CURRENT_USER_FILENAME.key -in $CURRENT_USER_FILENAME.crt -certfile $CA_SIGNED_CERT_FILENAME

  openssl x509 -in $CURRENT_USER_FILENAME.crt -noout -text
  openssl verify -CAfile $CA_SIGNED_CERT_FILENAME $CURRENT_USER_FILENAME.crt

}

CREATE_CA_ROOT_CERT
CREATE_SERVER_CERT

## declare an array variable of users
declare -a users=(
  "wsmith;Winston Smith wsmith;Minitrue"
  "bigbrother;Big Brother bigbrother;Minipax"
)

for user in "${users[@]}"
do
  echo "====STARTING $user==="
  CURRENT_USER_FILENAME=`echo $user | cut -d ";" -f 1`
  CURRENT_USER_COMMON_NAME=`echo $user | cut -d ";" -f 2`
  CURRENT_USER_ORG=`echo $user | cut -d ";" -f 3`
  CURRENT_USER_SUBJ="/C=US/ST=MD/L=Baltimore/O=$CURRENT_USER_ORG/OU=Domain Control/CN=$CURRENT_USER_COMMON_NAME/emailAddress=$CURRENT_USER_FILENAME@aml.com"

  echo $CURRENT_USER_FILENAME
  echo $CURRENT_USER_COMMON_NAME
  echo $CURRENT_USER_ORG

  CREATE_CLIENT_CERT
  # TODO: Finish
  echo '====FINISHED==='
done
