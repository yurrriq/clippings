IDRIS := idris
PKG   := clippings

.PHONY: build clean clean-all install rebuild doc doc-clean test

all: build

build:
	@$(IDRIS) --build $(PKG).ipkg

clean:
	@$(IDRIS) --clean $(PKG).ipkg
	@find . -name '*.ibc' -delete

clean-all: clean doc-clean

install:
	@$(IDRIS) --install $(PKG).ipkg

rebuild: clean build

doc:
	@$(IDRIS) --mkdoc $(PKG).ipkg

doc-clean:
	@rm -rf $(PKG)_doc/*
	@touch $(PKG)_doc/IdrisDoc

test:
	@$(IDRIS) --testpkg $(PKG).ipkg
