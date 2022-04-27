Draft

# Overview
* Creating Certificates
  * Running script to create all the certificates
* Ngnix
  * Installing Nginx
  * Configuring Nginx
  * Testing Certificates
* Backend
  * Running backend
* Center
  * Running Center
* Demo Auth Service
  * Running demo
* Websocket Service
* Configuring Firefox

## Creating Certificates
```
# Create directory for certificates, delete if exist
mkdir ~/certs
# Run script to create certs
sh create_certs.sh
# copy created certs into ~/certs
cp ~/git/dev-tools/certs/dist/* ~/certs
```
## Installing Nginx
Follow `ngnix_dev_setup.sh`

### Running nginx
```
~/init.d/nginx start
```

### Commands to test
go to the directory that contains the certificates (should be located in one of the directories)
```
cd ~/certs
cd ~/git/dev-tools/certs/dist
```

```
curl -kv https://localhost:4443/ --cacert ./ca_root.pem --cert ./bigbrother.crt --key ./bigbrother.pem
* About to connect() to localhost port 4443 (#0)
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 4443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* NSS: client certificate from file
* 	subject: E=bigbrother@aml.com,CN=Big Brother bigbrother,OU=Domain Control,O=Minipax,L=Baltimore,ST=MD,C=US
* 	start date: May 14 18:50:10 2018 GMT
* 	expire date: May 14 18:50:10 2019 GMT
* 	common name: Big Brother bigbrother
* 	issuer: E=admin@aml.com,CN=Demo ALM Root CA,OU=Domain Control,O=AML Demo CA,L=Baltimore,ST=MD,C=US
* SSL connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate:
* 	subject: E=admin@aml.com,CN=localhost,OU=Domain Control,O=AML Server,L=Baltimore,ST=MD,C=US
* 	start date: May 14 18:50:10 2018 GMT
* 	expire date: May 14 18:50:10 2019 GMT
* 	common name: localhost
* 	issuer: E=admin@aml.com,CN=Demo ALM Root CA,OU=Domain Control,O=AML Demo CA,L=Baltimore,ST=MD,C=US
> GET / HTTP/1.1cat
> User-Agent: curl/7.29.0
> Host: localhost:4443
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.9.4
< Date: Mon, 14 May 2018 18:59:24 GMT
< Content-Type: text/html
< Content-Length: 612
< Last-Modified: Mon, 14 May 2018 15:15:23 GMT
< Connection: keep-alive
< ETag: "5af9a80b-264"
< Accept-Ranges: bytes
<
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host localhost left intact

```
#### Common Errors:
```
Your curl is compiled with NSS support and by default it sends SSL certificated stored in /etc/pki/nssd.
We recommend to use curl which is linked against openssl (see https://gist.github.com/floragunncom/4eecb1586b426a19b77457228d331c43)
or make sure your certs in /etc/pki/nssd are sufficient (or your server truststore does accept them).
```


### Setting up backend
`https://github.com/aml-development/ozp-backend`

```
make use_psql use_es run_gunicorn_secure
```

if the certificates can not be found, go MakeFile and edit to :
```
--keyfile ~/certs/server_nopass.key \
--certfile ~/certs/server_nopass.crt \
--ca-certs ~/certs/ca_root.pem
```
OR
```
--keyfile ~/git/dev-tools/certs/dist/server_nopass.key \
--certfile ~/git/dev-tools/certs/dist/server_nopass.crt \
--ca-certs ~/git/dev-tools/certs/dist/ca_root.pem
```

Settings.py

```
diff --git a/ozp/settings.py b/ozp/settings.py
index 53e3624..12c8d63 100644
--- a/ozp/settings.py
+++ b/ozp/settings.py
@@ -201,8 +201,8 @@ USE_TZ = True
 REST_FRAMEWORK = {
     'EXCEPTION_HANDLER': 'ozpcenter.errors.exception_handler',
     'DEFAULT_AUTHENTICATION_CLASSES': (
-        # 'ozpcenter.auth.pkiauth.PkiAuthentication'
-        'rest_framework.authentication.BasicAuthentication',
+        'ozpcenter.auth.pkiauth.PkiAuthentication',
+        #'rest_framework.authentication.BasicAuthentication',
         'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
         # 'rest_framework.authentication.SessionAuthentication',
         ),
@@ -267,12 +267,13 @@ OZP = {
     'DEMO_APP_ROOT': 'https://localhost:8443',
     # if set to False, never try and update authorization-related info from
     # an external source
-    'USE_AUTH_SERVER': False,
+    'USE_AUTH_SERVER': True,
     # convert DNs read as /CN=My Name/OU=Something... to CN=My Name, OU=Something
     'PREPROCESS_DN': True,
     'OZP_AUTHORIZATION': {
-        'SERVER_CRT': '/ozp/server.crt',
-        'SERVER_KEY': '/ozp/server.key',
+        'SERVER_CRT': '/home/{userName}/certs/server_nopass.crt',
+        'SERVER_KEY': '/home/{userName}/certs/server_nopass.key',
+
         # assumes the real URL is <root>/users/<DN>/
         'USER_INFO_URL': r'http://localhost:8003/demo-auth/users/%s/info.json?issuerDN=%s',
         # assumes the real URL is <root>/users/<DN>/groups/<PROJECT_NAME>/
```

### Center
```
API_URL=https://berlin:4443 npm start
```

### Setting up demo-auth-service
`https://github.com/aml-development/demo-auth-service`
follow instructions from site
```
source env/bin/activate
make run
```
### Websocket Service
running ws service
```
nvm use 8.9.4
node server/index.js 
```

configure ws service
```
diff --git a/server/config.js b/server/config.js
index a892e10..d996e4f 100644
--- a/server/config.js
+++ b/server/config.js
@@ -3,5 +3,5 @@
 module.exports = {
   portNumber: process.env.PORT || 4200,
   redisAdapter: { host: 'localhost', port: 6379 },
-  backend2URL: 'http://127.0.0.1:8001'
+  backend2URL: 'http://localhost:8001'  // Do not forget to change for production
 };
```
```
diff --git a/server/service/backend2.js b/server/service/backend2.js
index 893b5ad..4826ecf 100644
--- a/server/service/backend2.js
+++ b/server/service/backend2.js
@@ -2,6 +2,10 @@

 const request = require('request');
 const config = require('../config');
+const fs = require('fs');
+
+// Load CA Cert - Production uncomment line below
+//const ca = fs.readFileSync('/home/{username}/certs/ca_root.pem', {encoding: 'utf-8'})

 /*
 {
@@ -23,7 +27,10 @@ function verifyToken(token){
         url: config.backend2URL + '/api/token-verify/',
         form: {
           token: token
-        }
+        },
+        rejectUnauthorized: true, // On production it needs to true
+        //ca: ca, //  Production uncomment line
+        // https://github.com/aacerox/node-rest-client/issues/126
       };
```


### Firefox Steps
Download Certs
```
http://berlin:8085/certs/ca_root.pem
http://berlin:8085/certs/wsmith.p12
http://berlin:8085/certs/bigbrother.p12
```

* Open Firefox (tested on 52.7.3)
* Add CA, and user certificates to Firefox
* Firefox -> Three Bars Menu -> Preference -> Advanced -> View Certificates
* Under Authorities -> add ca_root.pem
  * Check the first two
* Under Your Certificates add wsmith.p12 and bigbrother.p12
  * password is password

Go to https://berlin:4443/center/, it should open window where it will give you choice for which cert to use
