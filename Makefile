PKG   := clippings

.PHONY: build clean rebuild test

all: build

build:
	@ elba build

clean:
	@ elba clean

rebuild: clean build

test:
	@ elba test
