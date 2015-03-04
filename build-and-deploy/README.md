# Complete Build and Deployment for OZP

Clones, compiles, configures, and launches all OZP projects in an Ubuntu 14.04
VM (REST service, Center, HUD, Webtop, and IWC). The backend REST service uses 
a MySQL database and standalone elasticsearch instance (as opposed to an H2 
in-memory database and in-memory elasticsearch). In addition, the rest service
is deployed to tomcat as a WAR, as opposed to being run with `grails run-app`.
In this way, this development VM is reasonably well aligned with the 
production version of the software (though there are still non-trivial differences).

## Use
First, you must have Vagrant and VirtualBox installed on your host machine

```bash
vagrant up
vagrant ssh
# Follow the instructions to manually complete the install_prereqs.sh script (update tomcat memory, add tomcat user, generate SSL certs, etc)
# Modify Tomcat's server.xml file as per the comment in backend.sh
/vagrant/backend.sh
# After the server is up and running, run the newman commands to load test data
/vagrant/frontend.sh
# now you should be able to hit the resources listed in the Links section below.
# NOTE: You may need to load the rest API in a browser window first and 
# click to ignore security warnings before loading other applications
```

### Details
The bootstrap process consists of the custom scripts that are executed after
the basic vagrant box has been started (in this case, these scripts are what
clone, compile, configure, and deploy the OZP applications). There are 
three bootstrap scripts:

1. `install_prereqs.sh` - installs software (tomcat, mysql, node, grails, etc)
required for OZP applications and makes various configuration changes that should
only need to be done once (adjust Tomcat heap memory, create SSL certs, create
database users, etc)
2. `backend.sh` - clone, build, configure, and deploy the REST backend (ozp-rest)
3. `frontend.sh` - clone, build, configure, and deploy OZP front-end apps including:
 * Center
 * Webtop
 * HUD
 * IWC
 
Currently, all three scripts require some user interaction
and thus cannot be fully automated

## Links (from host)
    * [ozp-rest API](https://localhost:5443/marketplace/api) - user: testAdmin1, password: password
    * [Center](http://localhost:8000)
    * [HUD](http://localhost:8001)
    * [Webtop](http://localhost:8002/#/?ozpIwc.peer=http://localhost:8003)
    * [IWC Bus](http://localhost:8003)
    * [IWC Debugger](http://localhost:8003/debugger.html)
    * [HAL Browser](http://ozone-development.github.io/hal-browser/browser.html#https://localhost:5443/marketplace/api)
    
    * [Tomcat web UI](http://localhost:5808/manager/html/) (username: tomcat, password: password)

## Helpful Hints:
    * nginx error logs:  `/var/log/nginx/error.log`
    * restart nginx: `nginx -s reload`
    * stop a running grails app: `grails stop-app`
    * Logs (backend): /var/log/tomcat7/, /usr/share/tomcat7/logs/
    * verify that elasticsearch is running: `sudo netstat -lnp | grep 9300`
    * sudo multitail -i /usr/share/tomcat7/logs/marketplace.log -i /usr/share/tomcat7/logs/stacktrace.log -i /var/lib/tomcat7/logs/localhost_access_log.2015-03-02.txt -i /var/lib/tomcat7/logs/catalina.out -i /var/lib/tomcat7/logs/localhost.2015-03-02.log  -i /var/log/nginx/error.log -i /var/log/nginx/access.log  -s 2 -sn 4
    # multitail: F1 for help, O to clear all windows, o to clear specific window, 0..9 to set a marker in the correspond window to easily see what's changed, B to merge all into one
    * from Modern IE VMs, http://10.0.2.2 to get to host box. This means we need to adjust the paths in OzoneConfig.js to use 10.0.2.2 instead of localhost
    * IE testing: Always enable Cache->Always Refresh From Server option in F12 dev tools
