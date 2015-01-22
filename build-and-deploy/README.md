# Complete Build and Deployment for OZP

Clones, compiles, configures, and launches all OZP projects in an Ubuntu 14.04
VM

## Use
You must have Vagrant and VirtualBox installed on your host machine

```bash
vagrant up
vagrant ssh
cd ~/ozp-rest; grails run-app -https
```
(in another terminal)
```bash
vagrant ssh
cd ~/ozp-rest; # run newman commands at end of backend.sh
/vagrant/frontend.sh
```

`bootstrap.sh` is the primary provisioning script run by Vagrant (result of 
running `vagrant up`. It consists of 3 parts:

* `install_prereqs.sh`: install third-party dependencies (JDK, Grails, MySQL, etc)
* `backend.sh`: clone `ozp-rest`, configure, compile, and deploy using either
     Tomcat or the Grails development script. NOTE: Tomcat functionality doesn't
     work yet.
* `frontend.sh`: clone all front-end projects (IWC, Center, HUD, Webtop) and 
    deploy them via nginx
    
## Links (from host)
    * [ozp-rest API](https://localhost:5443/marketplace/api)
    * [Center](http://localhost:8000)
    * [HUD](http://localhost:8001)
    * [Webtop](http://localhost:8002?ozpIwc.peer=http://localhost:8003)
    * [OZP Data Utility](http://localhost:8004/ozpDataUtility/index.html)
    * [IWC Bus](http://localhost:8003)
    * [IWC Debugger](http://localhost:8003/debugger.html)
    * [HAL Browser](http://ozone-development.github.io/hal-browser/browser.html#https://localhost:5443/marketplace/api)

## Helpful Hints:
    * nginx error logs:  `/var/log/nginx/error.log`
    * restart nginx: `nginx -s reload`
    * stop a running grails app: `grails stop-app`
