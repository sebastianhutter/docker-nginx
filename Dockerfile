FROM debian:jessie

# add dotdeb repositories
ADD build/dotdeb.list /etc/apt/sources.list.d/dotdeb.list

RUN apt-get update \
  && apt-get install -y curl \
  && curl -fsSL https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
  && apt-get update \
  && apt-get install -y nginx-extras python python-pip \
  && pip install --upgrade j2cli \
  && rm -rf /var/lib/apt/lists/* /var/www/html/*

# copy default nginx configuration
ADD build/nginx.conf /etc/nginx/nginx.conf

# add the docker entrypoint script
ADD build/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# set the working directory
WORKDIR /

# expose http and https ports
EXPOSE 80 443
# run the docker entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
