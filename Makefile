jekyll := jekyll

builddir := build
deploydir := /var/www/site

run: $(src)
	$(jekyll) serve --detach

build: $(src)
	$(jekyll) build --destination $(builddir)

deploy: build
	rm -rf $(deploydir)/* && \
	rsync -r $(builddir)/* $(deploydir)/
