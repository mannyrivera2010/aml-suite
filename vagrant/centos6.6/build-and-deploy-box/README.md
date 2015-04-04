CentOS 6.6 OZP Build and Deploy Box
========================================
This Vagrant box will build, package, and deploy the following OZP applications:

* [REST service](https://localhost:7799/marketplace/api)
* [Center](https://localhost:7799/center)
* [HUD](https://localhost:7799/hud)
* [Webtop](https://localhost:7799/webtop)
* [IWC](https://localhost:7799/iwc)
* [Demo Apps](https://localhost:7799/demo_apps)
* [HAL Browser](https://localhost:7799/iwc/debugger.html#hal-browser/https://localhost:5443/marketplace/api)
* [Tomcat web UI](http://localhost:5808/manager/html/) (username: tomcat, password: password)

## Usage
First, install VirtualBox and Vagrant on your host, which are all available for
Windows, OS X, and Linux

You may also wish to install the `vagrant-vbguest` plugin which keeps your 
Guest Additions up to date: `vagrant plugin install vagrant-vbguest` (this may 
not work on a Windows host)

After that, simply run `vagrant up` in this directory and, after provisioning
is complete (**typically 35-45 minutes**), access the OZP applications from your 
host at the URLs listed above.

## Details 
ozp-rest is run under Tomcat, using an actual MySQL database and Elasticsearch 
instance (as opposed to the in-memory versions often used in development). The
front-end resources are hosted via nginx, and nginx is also used as a reverse 
proxy, such that all resources (front and back end) are served from the same 
domain. 

When this box is initially provisioned, `bootstrap.sh` is executed, which in 
turn runs four scripts:

* `initial_provisioning.sh`: installs dependencies (Java, Grails, MySQL, etc), 
configures dependencies, and copies **insecure** SSL keys for use by nginx and 
Tomcat. Unlike the other three scripts, this one should only need to be run once
* `build.sh`: clones the ozp applications from GitHub and builds them
* `package.sh`: tars and compresses the compiled output from the previous step
* `deploy.sh`: move the previously created artifacts to the right places, and 
perform any configuration required for deployment

## Helpful Hints:
    * nginx error logs:  `/var/log/nginx/error.log`
    * restart nginx: `nginx -s reload`
    * stop a running grails app: `grails stop-app`
    * Logs (backend): /var/log/tomcat7/, /usr/share/tomcat7/logs/
    * verify that elasticsearch is running: `sudo netstat -lnp | grep 9300`
    * sudo multitail -i /usr/share/tomcat7/logs/marketplace.log -i /usr/share/tomcat7/logs/stacktrace.log -i /var/lib/tomcat7/logs/localhost_access_log.2015-03-06.txt -i /var/lib/tomcat7/logs/catalina.out -i /var/lib/tomcat7/logs/localhost.2015-03-06.log  -i /var/log/nginx/error.log -i /var/log/nginx/access.log  -s 2 -sn 4
    # multitail: F1 for help, O to clear all windows, o to clear specific window, 0..9 to set a marker in the correspond window to easily see what's changed, B to merge all into one
    * from Modern IE VMs, http://10.0.2.2 to get to host box. This means we need to adjust the paths in OzoneConfig.js to use 10.0.2.2 instead of localhost
    * IE testing: Always enable Cache->Always Refresh From Server option in F12 dev tools
    * clear the elasticsearch data: curl -XDELETE 'http://localhost:9200/marketplace' (done on local box, not from host (would need port fwd))
    # elasticsearch data at /var/lib/elasticsearch

