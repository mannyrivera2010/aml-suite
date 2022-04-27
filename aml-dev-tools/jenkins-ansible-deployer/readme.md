**Deployment for Jenkins**    
In the jenkins Job configuation, in the Post-build Actions section, set up as following:  

> Archive the artifacts:    
File to archive: backend*.tar.gz  

---

> Send build artifacts over ssh:
>> SSH Server > Name: **    
>> Transer Set    
Exec Command -- ozp-backend
````bash
sudo /home/jenkins/ozp_deploy.sh ${JOB_NAME} ${BUILD_NUMBER} --es_enabled=True
````

Exec Command for the rest of jobs
````bash
sudo /home/jenkins/ozp_deploy.sh ${JOB_NAME} ${BUILD_NUMBER}
````


> Delete Workspace when build is done    
