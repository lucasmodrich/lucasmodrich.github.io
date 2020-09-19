.PHONY: clean update serve
clean:
	bundle exec jekyll clean
update:
	bundle update
install:
	bundle install
serve:
	bundle exec jekyll serve
