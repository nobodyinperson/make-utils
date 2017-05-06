#/usr/bin/make -f
# tests
THISFILE = $(strip $(firstword $(MAKEFILE_LIST)))

# include make-utils
MAKE_UTILS_PATH = . # relative path to make-utils repo folder
MAKE_UTILS_INCLUDES = $(wildcard $(realpath $(MAKE_UTILS_PATH))/*.mk) # find function files
include $(MAKE_UTILS_INCLUDES) # include the files

# files
APIDOC = api.rst
README_BASE = README-base.rst
README = README.rst
READMEHTML = README.html


#############################
### define test functions ###
#############################
define assert
ifeq ($1,$2)
$$(info OK)
else
$$(error <$1> is not <$2>)
endif
endef

define assert_result
ifeq ($$(RESULT),$1)
$$(info OK)
else
$$(error <$$(RESULT)> is not <$1>)
endif
endef

#####################
### Run the tests ###
#####################
PREFIX = 1234
SUFFIX = qwer
EXTENSION = txt

FILENAME = $(PREFIX)_$(SUFFIX).$(EXTENSION)
REGEX = ^(?<pre>\d+)_(?<suf>\w+)\.(?<ext>\w+)$

### apply_perl_regex ###
RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{pre}))
$(eval $(call assert_result,$(PREFIX)))
RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{suf}))
$(eval $(call assert_result,$(SUFFIX)))
RESULT = $(shell $(call apply_perl_regex,$(FILENAME),$(REGEX),$$+{ext}))
$(eval $(call assert_result,$(EXTENSION)))

### match_perl_regex ###
$(eval $(call match_perl_regex,$(FILENAME),$(REGEX)))
$(eval $(call assert,$(pre),$(PREFIX)))
$(eval $(call assert,$(suf),$(SUFFIX)))
$(eval $(call assert,$(ext),$(EXTENSION)))

### scan_file_until ###
COND = s/^define\s+(\w+)$$/$$1/g # Makefile variable definition -> get name
RESULT = $(shell $(call scan_file_until,$(THISFILE),$(COND))) # get first defined function in this file
$(eval $(call assert,$(RESULT),assert)) # first function defined in this file is assert
# no function defined in the README base file
$(eval $(call assert,$(shell $(call scan_file_until,$(README_BASE),$(COND))),))

### download_url_to_file ###
TMPFILE = google.html
$(shell $(call download_url_to_file,google.com,$(TMPFILE))) # download google
$(eval $(call assert,$(shell /bin/sh -c 'file $(TMPFILE) | grep -iq "html";echo $$?'),0))
$(shell rm -rf $(TMPFILE))

###############
### targets ###
###############
all: test $(README) $(READMEHTML)

test:
	@echo All tests passed!

$(APIDOC): $(MAKE_UTILS_INCLUDES)
	cat $^ | perl -ne 'print if (s/^# //g)' > $@

$(README): $(README_BASE) $(APIDOC)
	cat $^ > $@

%.html: %.rst
	pandoc --standalone -t html -o $@ -i $<

.PHONY: clean
clean:
	rm -rf $(README) $(APIDOC) $(READMEHTML)

