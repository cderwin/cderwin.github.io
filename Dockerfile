FROM debian:jessie

# ruby deps
RUN apt-get update && apt-get install -y \
    build-essential \
    git-core \
    curl \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    python-software-properties \
    libffi-dev

# rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    cd ~/.rbenv && src/configure && make -C src && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install ruby and bundler
RUN . /root/.bashrc && \
    rbenv install 2.2.3 -v && \
    rbenv global 2.2.3 && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    gem install bundler && \
    rbenv rehash

# Install nginx
RUN \
    . /root/.bashrc && \
    apt-get install -y nginx && \
    rm -rf /etc/nginx/sites-enabled/default && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf
COPY config/nginx.conf /etc/nginx/conf.d/site.conf
RUN /usr/sbin/nginx -t

COPY . /src/
WORKDIR /src/
RUN . /root/.bashrc && \
    make deploy

EXPOSE 80
ENTRYPOINT /usr/sbin/nginx
