IDRIS := idris
PKG   := clippings

.PHONY: build clean clobber install rebuild test docs docs-clean test

all: build

build:
	@$(IDRIS) --build $(PKG).ipkg

clean:
	@$(IDRIS) --clean $(PKG).ipkg
	@find . -name '*.ibc' -delete

clobber: clean docs-clean

install:
	@$(IDRIS) --install $(PKG).ipkg

rebuild: clean build

test:
	@$(IDRIS) --testpkg $(PKG).ipkg

docs: build docs-clean
	@$(IDRIS) --mkdoc $(PKG).ipkg \
	&& rm -rf docs >/dev/null \
	&& mv $(PKG)_doc docs

docs-clean:
	@rm -rf $(PKG)_doc docs >/dev/null
