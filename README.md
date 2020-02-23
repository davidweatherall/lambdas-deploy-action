# Lambdas Deploy Action

```yaml
name: Production Build
on:
  pull_request:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
        
    steps:
    - uses: actions/checkout@v1
    - name: Deploy to Lambda
      uses: davidweatherall/lambdas-deploy-action@master
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_REGION: ${{ secrets.AWS_REGION }}
        AWS_LAMBDA_NAME: lambdaName
        AWS_LAMBDA_VERSION: Production

```


### Configuration

| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | **Yes** | N/A |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | **Yes** | N/A |
| `AWS_REGION` | AWS region of lambda. | No | `us-east-2` |
| `AWS_LAMBDA_NAME` | Name of the lambda | **Yes** | N/A |
| `AWS_LAMBDA_VERSION` | Lambda Version (this should probably be made optional) | **Yes** | N/A |


## Licensed under [MIT](LICENSE.md).

