#/bin/bash
sleep 3 && aws --profile web-deploy s3 cp --recursive ./www/public s3://<bucket>
