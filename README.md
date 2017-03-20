# openshift-jenkins

## EBS volumes

The Jenkins data is persisted in EBS volumes and used as `PersistentVolume` in
the OpenShift cluster. The EBS volumes are created by the CloudFormation
template in `cf.yml`. The EBS volume ID is passed as an input to the OpenShift
template.

## OpenShift application

The Jenkins application is represented by the template `openshift-template.yml`.
The template must first be added to the cluster and a new application can be
created using the following command -

```sh

# Add policy for service account
oadm policy add-scc-to-user anyuid -z default
oadm policy add-scc-to-user anyuid -z builder
oadm policy add-scc-to-user anyuid -z deployer
oadm policy add-scc-to-user anyuid -z jenkins-user

# Create application
oc new-app --template=jenkins \
  -p APPLICATION_HOSTNAME=jenkins.apps.ose.isubuz.com \
  -p JENKINS_DOCKER_IMAGE='isubuz/jenkins' \
  -p JENKINS_DOCKER_TAG='2.32.3' \
  -p JENKINS_VOL_ID=vol-0346a6530cfea8c2c \
  -p JENKINS_VOL_SIZE=100Gi
```

## Steps

- Create the CloudFormation stack with the EBS volumes
- (Optional) Build docker image and push to registry
- Add template to OpenShift cluster
- Create new app passing the required parameters