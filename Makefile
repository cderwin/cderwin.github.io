jekyll := jekyll

builddir := build
deploydir := /var/www/site

src := $(shell find . -type f)

run: $(src)
	$(jekyll) serve --detach

build: $(src)
	$(jekyll) build --destination $(builddir)

deploy: build
	rm -rf $(deploydir)/* && \
	mkdir -p $(deploydir) && \
	rsync -r $(builddir)/* $(deploydir)/
