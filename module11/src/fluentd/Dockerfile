FROM fluent/fluentd:v1.16-debian-1
USER root

RUN gem uninstall -I fluent-plugin-elasticsearch || true
RUN gem uninstall -I elasticsearch || true

RUN gem install elasticsearch -v 7.13.3
RUN gem install fluent-plugin-elasticsearch -v 5.0.5

USER fluent