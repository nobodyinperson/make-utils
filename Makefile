#/usr/bin/make -f
# tests

include regex.mk

define assert_result
ifeq ($$(RESULT),$1)
$$(info OK)
else
$$(error <$$(RESULT)> is not <$1>)
endif
endef

define assert
ifeq ($1,$2)
$$(info OK)
else
$$(error <$1> is not <$2>)
endif
endef

PREFIX = 1234
SUFFIX = qwer
EXTENSION = txt

FILENAME = $(PREFIX)_$(SUFFIX).$(EXTENSION)
REGEX = ^(?<pre>\d+)_(?<suf>\w+)\.(?<ext>\w+)$

RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{pre}))
$(eval $(call assert_result,$(PREFIX)))
RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{suf}))
$(eval $(call assert_result,$(SUFFIX)))
RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{ext}))
$(eval $(call assert_result,$(EXTENSION)))

$(eval $(call match_perl_regex,$(REGEX),$(FILENAME)))
$(eval $(call assert,$(pre),$(PREFIX)))
$(eval $(call assert,$(suf),$(SUFFIX)))
$(eval $(call assert,$(ext),$(EXTENSION)))

test:
	@echo All tests passed!
