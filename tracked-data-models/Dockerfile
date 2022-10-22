FROM debian:9

# jq
RUN apt-get update && apt-get install -y jq
# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY /tracked-data-models/sql-runner-linux /sql-runner-linux
COPY /tracked-data-models/entrypoint.sh /entrypoint.sh
COPY /tracked-data-models/run_config.sh /run_config.sh
ADD templates /templates
ADD web /web

WORKDIR /

RUN chmod +x /entrypoint.sh
RUN chmod +x /run_config.sh

# set start command
ENTRYPOINT ["/entrypoint.sh"]