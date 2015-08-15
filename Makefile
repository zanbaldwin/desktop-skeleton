default:

dependencies:
	npm install

clean:
	rm -rf ./build

build: clean dependencies
	### Create build directory.
	mkdir -p ./build
	### Install NPM (non-dev) and Bower dependencies.
	(mkdir -p ./build/node_modules; cp ./package.json ./build/package.json; npm install --prefix ./build --production)
	(cp ./bower.json ./src/bower.json; cd src; bower install; rm ./bower.json)
	### Compile source code (process; back-end).
	./node_modules/.bin/iced --output ./build --bare --no-header --compile ./src
	### Copy page templates to build folder.
	cp ./src/index.html ./build/index.html
	cp -r ./src/pages ./build/pages
	### Compile LessCSS documents.
	./node_modules/.bin/lessc ./src/assets/styles/main.less ./build/assets/main.css
	### Copy layout documents to build folder.
	cp -r ./src/assets/layout ./build/assets/layout
	### Compile JavaScript assets (renderer; front-end).
	./node_modules/.bin/iced --output ./build/assets/scripts --bare --no-header --compile ./src/assets/scripts
	### Combine Polymer elements.
	./node_modules/.bin/vulcanize ./src/elements.html > ./build/elements.html
	mv ./src/bower_components ./build/bower_components
	### Copy image assets to build folder.
	cp -r ./src/assets/images ./build/assets/images

run:
	./node_modules/.bin/electron ./build
