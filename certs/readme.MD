### Installing Nginx
```
mkdir -p ~/usr/local
./configure --with-http_ssl_module --prefix=`echo ~`/usr/local/ngnix
make
make install
```



### Commands to test

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
