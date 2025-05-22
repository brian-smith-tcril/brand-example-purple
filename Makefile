# minimal build with just the overrides
# this is ideal when loading styles from a CDN
build:
	rm -rf dist && mkdir dist
	npm run build-tokens
	npm run build-scss

# full build including paragon core styles
# this is currently required when using the
# classic npm alias method.
# 
# ideally this will not always be the case
# see: https://github.com/openedx/frontend-build/issues/652
build-with-core:
	rm -rf dist && mkdir dist
	npm run build-tokens
	npm run build-scss-with-core
