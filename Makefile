.PHONY: clean update serve
clean:
	bundle exec jekyll clean
update:
	bundle update
install:
	bundle install
serve: clean
	bundle exec jekyll serve
