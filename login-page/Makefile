.DEFAULT: run

# To view the login page:
# 1) Run "make" to build and run the web server.
# 2) Open "http://localhost" in your favorite browser.
#
# For quicker iterative development, you can instead use "make run-live" which
# allows you to make live updates to the content without restarting the server.

IMAGE := login-page

.PHONY: run
run: image
	@echo
	@echo '*****************************************************'
	@echo '** Visit "http://localhost" to view the login page **'
	@echo '*****************************************************'
	@echo
	docker run --rm -p 80:80 $(IMAGE)

.PHONY: image
image:
	docker build -t $(IMAGE) .

.PHONY: run-live
run-live:
	docker run --rm -p 80:80 -v $(PWD)/html:/usr/share/nginx/html:ro nginx
