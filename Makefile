ifneq (,)
.error This Makefile requires GNU Make.
endif

# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
.PHONY: help lint test

FL_VERSION = 0.3
FL_IGNORES = .git/,.github/


# -------------------------------------------------------------------------------------------------
# Default Target
# -------------------------------------------------------------------------------------------------
help:
	@echo "lint             Lint repository"
	@echo "test             Run integration tests"


# -------------------------------------------------------------------------------------------------
# Lint Targets
# -------------------------------------------------------------------------------------------------
lint: _lint-files
lint: _lint-shell


.PHONY: _lint-files
_lint-files:
	@echo "# -------------------------------------------------------------------- #"
	@echo "# Lint files"
	@echo "# -------------------------------------------------------------------- #"
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-cr --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-crlf --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-single-newline --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-space --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8 --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8-bom --text --ignore '$(FL_IGNORES)' --path .

.PHONY: _lint-shell
_lint-shell:
	@echo "# -------------------------------------------------------------------- #"
	@echo "# Shellcheck"
	@echo "# -------------------------------------------------------------------- #"
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt -w /mnt koalaman/shellcheck:stable watcherd


# -------------------------------------------------------------------------------------------------
# Test Targets
# -------------------------------------------------------------------------------------------------
test:
	./tests/01.sh
