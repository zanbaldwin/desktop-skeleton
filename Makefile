usage:
	@echo "Usage: make <command>"
	@echo ""
	@echo "Available commands:"
	@echo "    clean             Clean project of dependency and build files."
	@echo "    dependencies      Install project dependencies."
	@echo "    assets            Compile all assets."
	@echo "    run               Run application from source."
	@echo "    build             Build application from source."
	@echo "    run-build         Run built application."

clean:
	rm -rf build
	rm -rf node_modules
	rm -rf bower_components
	find src -name "*.js" ! -path "src/index.js" -type f -delete
	find src -name "*.css" -type f -delete

dependencies:
	npm install
	bower install

assets:
	./node_modules/.bin/coffee --output src --bare --no-header --compile src
	./node_modules/.bin/lessc src/assets/styles/main.less src/assets/styles/main.css

# Run the application without compiling. Slower but easier for development.
run: dependencies assets
	./node_modules/.bin/electron ./src

# Compile all assets for a faster application.
build: dependencies assets
	cp -r src build
	# Remove the bootstrapping script, and replace with the actual application script.
	rm build/index.js
	mv build/app.js build/index.js
	# Remove source files of compiled assets.
	find build -name "*.coffee" -type f -delete
	find build -name "*.less" -type f -delete

run-build: build
	./node_modules/.bin/electron ./build
