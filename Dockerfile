FROM python:3.8-alpine

ENV AWSCLI_VERSION='1.17.1'

RUN apk add --update zip
RUN apk add --update jq

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
