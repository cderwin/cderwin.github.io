bundle := bundle
bundle_pfx := bundle exec

jekyll := $(bundle_pfx) jekyll
jekyll_args := --source src

srcdir := src
builddir := build
deploydir := /var/www/site

src := $(shell find . -type f)

.PHONY: run kill test

all: build

.install.ts: Gemfile
	bundle install && \
	touch $@

run: $(src)
	$(jekyll) serve $(jekyll_args)

kill:
	kill -9 `lsof -ti :4000`

build: $(src) .install.ts
	$(jekyll) build $(jekyll_args)

deploy: build
	rm -rf $(deploydir)/* && \
	mkdir -p $(deploydir) && \
	rsync -r $(builddir)/* $(deploydir)/
