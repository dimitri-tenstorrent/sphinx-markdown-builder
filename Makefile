# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINX_OPTS    ?=
SPHINX_BUILD   ?= sphinx-build
SOURCE_DIR      = docs-tests
BUILD_DIR       = docs-build

.PHONY: help clean test meld release

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINX_BUILD) -M help "$(SOURCE_DIR)" "$(BUILD_DIR)" $(SPHINX_OPTS) $(O)

clean:
	rm -rf "$(BUILD_DIR)" "$(SOURCE_DIR)/library"

# Catch-all target: route all unknown targets to Sphinx using the new "make mode" option.
# $(O) is meant as a shortcut for $(SPHINX_OPTS).
doc-%:
	@$(SPHINX_BUILD) -M $* "$(SOURCE_DIR)" "$(BUILD_DIR)" $(SPHINX_OPTS) $(O)


docs: doc-markdown


test:
	@$(SPHINX_BUILD) -M markdown "$(SOURCE_DIR)" "$(BUILD_DIR)" $(SPHINX_OPTS) $(O) -a -t Partners
	diff --recursive "$(BUILD_DIR)/markdown" "$(SOURCE_DIR)/_expected"

meld:
	meld "$(BUILD_DIR)/markdown" "$(SOURCE_DIR)/_expected"

release:
	@rm -rf dist/*
	python3 -m build || exit
	python3 -m twine upload --repository sphinx_markdown_builder dist/*
