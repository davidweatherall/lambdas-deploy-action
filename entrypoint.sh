#!/bin/sh

set -e

if [ -z "$AWS_LAMBDA_NAME" ]; then
  echo "AWS_LAMBDA_NAME is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_LAMBDA_VERSION" ]; then
  echo "AWS_LAMBDA_VERSION is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-2"
fi


aws configure --profile lambdas-deploy-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

cd $AWS_LAMBDA_NAME
zip -r ../$AWS_LAMBDA_NAME.zip *
cd ../

old_version=`aws lambda get-function --function-name $AWS_LAMBDA_NAME --qualifier $AWS_LAMBDA_VERSION  --profile lambdas-deploy-action --output json | jq -r .Configuration.Version`

aws lambda update-function-code --function-name $AWS_LAMBDA_NAME --zip-file fileb://$AWS_LAMBDA_NAME.zip --profile lambdas-deploy-action

aws lambda publish-version --function-name $AWS_LAMBDA_NAME --profile lambdas-deploy-action --output json

version=`aws lambda publish-version --function-name $AWS_LAMBDA_NAME --profile lambdas-deploy-action --output json | jq -r .Version`

aws lambda update-alias --function-name $AWS_LAMBDA_NAME --function-version $version --name $AWS_LAMBDA_VERSION --profile lambdas-deploy-action

aws lambda get-function --function-name $AWS_LAMBDA_NAME  --profile lambdas-deploy-action

aws lambda invoke --function-name $AWS_LAMBDA_NAME --qualifier $AWS_LAMBDA_VERSION lambda_output.txt  --profile lambdas-deploy-action

cat lambda_output.txt

aws lambda delete-function --function-name $AWS_LAMBDA_NAME:$old_version --profile lambdas-deploy-action

aws configure --profile lambdas-deploy-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
