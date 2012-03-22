.PHONY: deploy watch clean touch
project=node-slides
path=/var/www/node-slides
instance=\033[36;01m${project}\033[m

all: watch
deploy: server = sawyer@172.25.20.120
deploy:
	@coffee -c app.coffee
	@rsync -az --exclude=".git" --exclude="node_modules/*/build" --delete --delete-excluded * ${server}:${path}
	@echo -e " ${instance} | copied files to ${server}"
	@ssh ${server} "cd ${path} && npm rebuild"
	@echo -e " ${instance} | built npm packages on ${server}"
	@ssh ${server} "sudo cp -f ${path}/upstart.conf /etc/init/${project}.conf"
	@echo -e " ${instance} | setting up upstart on ${server}"
	@ssh ${server} "sudo restart ${project}"
	@echo -e " ${instance} | restarting app on ${server}"
	@make -s clean
	@sleep 1
	@make -s touch

touch: server = sawyer@172.25.20.120
touch:
	@wget -r -l 1 -q http://slides.wavded.com/
	@echo -e " ${instance} | built main assets on ${server}"
	@wget -r -l 1 -q http://slides.wavded.com/clicker
	@echo -e " ${instance} | built clicker assets on ${server}"
	@rm -rf slides.wavded.com

watch:
	@if ! which supervisor > /dev/null; then echo "supervisor required, installing..."; sudo npm install -g supervisor; fi
	@supervisor -w assets,views,app.coffee app.coffee

clean:
	@rm app.js
	@echo -e " ${instance} | cleaned"
