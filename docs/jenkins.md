## Download and running Jenkins
```
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
java -jar jenkins.war --httpPort=8082
```

* Browse to http://localhost:8080
* Follow instructions

## Setting up ozp-backend on Jenkins CI

* Create a new folder called `ozp`
* Create a new `freestyle project` called `ozp-backend`
* Under the General tab
    * Select `Discard Old Builds` with `Log Rotation` Strategy
        * Max # of builds to keep `2`
    * Select `Github project`, make `project_url` to `https://github.com/aml-development/ozp-backend/`

TODO Finish
