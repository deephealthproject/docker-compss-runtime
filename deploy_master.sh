#!/bin/bash

curl --location --request POST 'http://deephealth.treelogic.com/api/importYamlPods/default?cluster=onpremise' \
--header 'Content-Type: text/plain' \
--header 'Accept: application/json' \
--header 'Authorization: Basic YnNjOkQzM3BIMzRsdGgh' \
--data-raw 'apiVersion: v1
kind: Pod
metadata:
  namespace: default
  name: compss-master
  labels:
    app: compss-master
spec:
  containers:
  - name: compss-master
    image: bscppc/compss-deephealth-demo
    tty: true
'
 echo ""
