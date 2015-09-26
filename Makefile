default:

dependencies:
	npm install
	bower install

clean:
	rm -rf build
	rm -rf node_modules
	rm -rf bower_components

assets:

# Compile all assets for a faster application.
build: dependencies
	cp -r src build
	# Compile sources.
	./node_modules/.bin/coffee --output build --bare --no-header --compile src
	./node_modules/.bin/lessc build/assets/styles/main.less build/assets/styles/main.css
	# Vulcanise the Polymer elements.
	rm -rf build/elements
	./node_modules/.bin/vulcanize --strip-comments src/elements.html > build/elements.html
	# Remove the bootstrapping script, and replace with the actual application script.
	rm build/index.js
	mv build/app.js build/index.js

run-build:
	./node_modules/.bin/electron ./build

# Run the application without compiling. Slower but easier for development.
run: dependencies
	./node_modules/.bin/electron ./src
