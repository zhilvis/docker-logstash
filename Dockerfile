FROM java:7

RUN curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz | tar -xz -C /opt

# Install contrib plugins
RUN /opt/logstash-1.4.2/bin/plugin install contrib

ADD config.json /tmp/
ADD ssl /tmp/
ADD docker.rb /opt/logstash-1.4.2/lib/logstash/filters/

EXPOSE 9292 5043

CMD ["/opt/logstash-1.4.2/bin/logstash","agent","--verbose", "--config","/tmp/config.json","--","web"]

