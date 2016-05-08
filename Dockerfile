FROM ruby:alpine

RUN apk add --update \
    nginx \
    rsync \
    make \
    gcc \
    musl-dev

COPY Gemfile /code/Gemfile
WORKDIR /code/
RUN bundle install

COPY . /code/
RUN bundle exec jekyll build && \
    rsync -a /code/build/* /var/www/site

ADD config/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["/usr/sbin/nginx"]
