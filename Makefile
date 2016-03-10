SHELL := bash

bundle := bundle
bundle_pfx := bundle exec

jekyll := $(bundle_pfx) jekyll
jekyll_args := 

srcdir := src
builddir := build
deploydir := /var/www/site

src := $(shell find . -type f)

.PHONY: run kill restart test

all: build

.install.ts: Gemfile
	echo $$PATH && \
	bundle install && \
	touch $@

run: $(src)
	$(jekyll) serve $(jekyll_args)

kill:
	kill -9 `lsof -ti :4000`

restart: kill run

build: $(src) .install.ts
	$(jekyll) build $(jekyll_args)

deploy: build
	mkdir -p $(deploydir) && \
	rsync -a $(builddir)/* $(deploydir)

clean:
	rm .*.ts
