FROM ruby:2.3

LABEL Description="Chouette GUI" \
      Usage="docker run -it --name chouette2 --link chouette-postgres:chouette-postgres --link chouette-redis:chouette-redis --link chouette-iev:chouette-iev -p 3000:3000 -d chouette-gui" \
      BuildUsage="docker build -t chouette-gui ." \
      License="CECILL/B" \
      Version="4.0.0"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales nmap libproj-dev vim libpq-dev git unzip libgeos-dev proj-bin make apt-utils

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN useradd -ms /bin/bash chouette

USER chouette

RUN cd /home/chouette/ && git clone https://github.com/atnos/chouette2.git && cd chouette2 && bundle install --without development test

RUN mkdir /home/chouette/bin
COPY config/chouette.sh /home/chouette/bin/
COPY config/docker-entrypoint.sh /home/chouette/bin/
COPY config/database.yml /home/chouette/chouette2/config/
COPY config/smtp_settings.rb /home/chouette/chouette2/config/initializers/
COPY config/env /home/chouette/chouette2/.env

USER root

RUN chmod 777 /home/chouette/bin/chouette.sh
RUN chmod 777 /home/chouette/bin/docker-entrypoint.sh

EXPOSE 3000

USER chouette

VOLUME ["/home/chouette/referentials"]
ENTRYPOINT ["/home/chouette/bin/docker-entrypoint.sh"]
# ENTRYPOINT ["bin/bash"]
