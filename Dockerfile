FROM ubuntu:12.04
MAINTAINER Helmi <helmi@tuxuri.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install ca-certificates
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgis
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN service postgresql start
RUN /bin/su postgres -c "createuser -d -s -r -l docker"
RUN /bin/su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\""
RUN /bin/su postgres -c "psql postgres -c \"CREATE EXTENSION postgis\""
RUN /bin/su postgres -c "psql postgres -c \"CREATE EXTENSION postgis_topology\""
RUN /bin/su postgres -c "psql postgres -c \"CREATE EXTENSION fuzzystrmatch\""
RUN /bin/su postgres -c "psql postgres -c \"CREATE EXTENSION postgis_tiger_geocoder\""
RUN service postgresql stop
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
