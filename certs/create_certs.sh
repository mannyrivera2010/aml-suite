#!/usr/bin/env bash
# Script used to create Certificates
# based on http://nategood.com/client-side-certificate-authentication-in-ngi
# https://gist.github.com/Soarez/9688998
rm *.key *.txt *.pem *.crt *.csr *.p12 dist* -fr
mkdir -p dist

CA_SUBJ='/C=US/ST=MD/L=Baltimore/O=AML Demo CA/OU=Domain Control/CN=Demo ALM Root CA/emailAddress=admin@aml.com'

WORKING_FOLDER_PREFIX='dist/'
DIST_FOLDER_PREFIX='dist/'

CA_KEY_FILENAME=$WORKING_FOLDER_PREFIX'ca_root.key'
CA_SIGNED_CERT_FILENAME=$WORKING_FOLDER_PREFIX'ca_root.crt'
CA_SIGNED_PEM_FILENAME=$WORKING_FOLDER_PREFIX'ca_root.pem'
CA_PASSWORD_FILENAME=$WORKING_FOLDER_PREFIX'ca_passphrase.txt'

SERVER_SUBJ='/C=US/ST=MD/L=Baltimore/O=AML Server/OU=Domain Control/CN=localhost/emailAddress=admin@aml.com'

SERVER_KEY_FILENAME=$WORKING_FOLDER_PREFIX'server.key'
SERVER_REQUEST_FILENAME=$WORKING_FOLDER_PREFIX'server.csr'
SERVER_SIGNED_CERT_FILENAME=$WORKING_FOLDER_PREFIX'server.crt'

SERVER_NOPASS_KEY_FILENAME=$WORKING_FOLDER_PREFIX'server_nopass.key'
SERVER_NOPASS_REQUEST_FILENAME=$WORKING_FOLDER_PREFIX'server_nopass.csr'
SERVER_SIGNED_NOPASS_CERT_FILENAME=$WORKING_FOLDER_PREFIX'server_nopass.crt'

SERVER_PASSWORD_FILENAME=$WORKING_FOLDER_PREFIX'server_passphrase.txt'

CREATE_CA_ROOT_CERT(){
  # Create the CA Key and Certificate for signing Client Certs
  openssl rand -base64 48 > $CA_PASSWORD_FILENAME
  openssl genrsa -des3 -passout file:$CA_PASSWORD_FILENAME -out $CA_KEY_FILENAME 4096
  openssl req -new -passin file:$CA_PASSWORD_FILENAME -x509 -days 365 -key $CA_KEY_FILENAME  -subj "$CA_SUBJ" -out $CA_SIGNED_CERT_FILENAME
  openssl x509 -in $CA_SIGNED_CERT_FILENAME -out $CA_SIGNED_PEM_FILENAME  -outform PEM
}

CREATE_SERVER_CERT(){
  # Create the Server Key, CSR, and Certificate
  # We're self signing our own server cert here.  This is a no-no in production.
  echo 'password1!' > $SERVER_PASSWORD_FILENAME
  openssl genrsa -des3 -passout file:$SERVER_PASSWORD_FILENAME -out $SERVER_KEY_FILENAME 2048
  openssl req -new -passin file:$SERVER_PASSWORD_FILENAME -key $SERVER_KEY_FILENAME -subj "$SERVER_SUBJ" -out $SERVER_REQUEST_FILENAME
  openssl x509 -req -days 365 -in $SERVER_REQUEST_FILENAME -passin file:$CA_PASSWORD_FILENAME -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $SERVER_SIGNED_CERT_FILENAME

  # Create the Server Key, CSR, and Certificate used for apache or ngnix servers
  # We're self signing our own server cert here.  This is a no-no in production.
  openssl genrsa -out $SERVER_NOPASS_KEY_FILENAME 2048
  openssl req -new -nodes -key $SERVER_NOPASS_KEY_FILENAME -subj "$SERVER_SUBJ" -out $SERVER_NOPASS_REQUEST_FILENAME
  openssl x509 -req -days 365 -in $SERVER_NOPASS_REQUEST_FILENAME -passin file:$CA_PASSWORD_FILENAME -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $SERVER_SIGNED_NOPASS_CERT_FILENAME
}

CREATE_CLIENT_CERT(){

  # Create the Client Key and CSR
  # We're self signing our own server cert here.  This is a no-no in production.
  openssl genrsa -des3 -passout file:$SERVER_PASSWORD_FILENAME -out $CURRENT_USER_KEY_FILENAME 2048
  openssl rsa -in $CURRENT_USER_KEY_FILENAME -passin file:$SERVER_PASSWORD_FILENAME -out $CURRENT_USER_KEY_PEM_NOPASS_FILENAME

  openssl req -new -passin file:$SERVER_PASSWORD_FILENAME -key $CURRENT_USER_KEY_FILENAME -subj "$CURRENT_USER_SUBJ" -out $CURRENT_USER_REQUEST_FILENAME
  openssl x509 -req -days 365 -in $CURRENT_USER_REQUEST_FILENAME -passin file:$CA_PASSWORD_FILENAME -CA $CA_SIGNED_CERT_FILENAME -CAkey $CA_KEY_FILENAME -CAcreateserial -out $CURRENT_USER_SIGNED_CERT_FILENAME

  openssl pkcs12 -export -passin file:$SERVER_PASSWORD_FILENAME -password pass:password -out $CURRENT_USER_SIGNED_P12_CERT -inkey $CURRENT_USER_KEY_FILENAME -in $CURRENT_USER_SIGNED_CERT_FILENAME -certfile $CA_SIGNED_CERT_FILENAME

  openssl x509 -in $CURRENT_USER_SIGNED_CERT_FILENAME -noout -text
  openssl verify -CAfile $CA_SIGNED_CERT_FILENAME $CURRENT_USER_SIGNED_CERT_FILENAME

}

CREATE_CA_ROOT_CERT
CREATE_SERVER_CERT

## declare an array variable of users,
## each user defined as {username};{user dn}:{organization}
declare -a users=(
  "wsmith;Winston Smith wsmith;Minitrue"
  "bigbrother;Big Brother bigbrother;Minipax"
)

for user in "${users[@]}"
do
  echo "====STARTING $user==="
  CURRENT_USER_NAME=`echo $user | cut -d ";" -f 1`
  CURRENT_USER_COMMON_NAME=`echo $user | cut -d ";" -f 2`
  CURRENT_USER_ORG=`echo $user | cut -d ";" -f 3`
  CURRENT_USER_SUBJ="/C=US/ST=MD/L=Baltimore/O=$CURRENT_USER_ORG/OU=Domain Control/CN=$CURRENT_USER_COMMON_NAME/emailAddress=$CURRENT_USER_NAME@aml.com"

  CURRENT_USER_FILENAME=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME
  CURRENT_USER_KEY_FILENAME=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME.key
  CURRENT_USER_KEY_PEM_NOPASS_FILENAME=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME.pem
  CURRENT_USER_REQUEST_FILENAME=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME.csr
  CURRENT_USER_SIGNED_CERT_FILENAME=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME.crt
  CURRENT_USER_SIGNED_P12_CERT=$WORKING_FOLDER_PREFIX$CURRENT_USER_NAME.p12

  echo 'Username: '$CURRENT_USER_NAME
  echo 'User Common Name: ' $CURRENT_USER_COMMON_NAME
  echo 'User Org: '$CURRENT_USER_ORG

  CREATE_CLIENT_CERT
  # TODO: Finish
  echo '====FINISHED==='
done
