#!/usr/bin/make -f

# 
# .. role:: perl(code)
# 	:language: perl
# 

# Documentation
# =============
# 

# :code:`apply_perl_regex`
# ++++++++++++++++++++++++
# 
# .. code:: makefile
# 
# 	SHELLCODE =       $(call apply_perl_regex,STRING,REGEX,RESULT)
# 	MATCHED = $(shell $(call apply_perl_regex,STRING,REGEX,RESULT))
# 
# STRING - string
# 	the string to match :code:`REGEX` against
# REGEX - Perl regular expression
# 	the regex to match
# RESULT - Perl code
# 	the result
# 
# Function to return an executable shell command that:
# 
# 1. gives the argument STRING to Perl
# 2. matches the Perl-regex-like REGEX (with :perl:`m//x`) on it
# 3. evaluates and prints the Perl-code-like argument RESULT. 
# 
# This is handy for back-reference with the Perl variables :perl:`$1` to
# :perl:`$9` or :perl:`$+{key}`
# 
# .. code:: makefile
# 
# 	REGEX = ^(\w+)_(\d+)\.(\w+)$
# 	RESULT = "first: <$$1> second: <$$2> third: <$$3>"
# 	MATCHED = $(shell $(call apply_perl_regex,asdf_1234.txt,$(REGEX),$(RESULT)))
# 	$(info $(MATCHED))
# 	# first: <asdf> second: <1234> third: <txt>
# 
# 	REGEX = (?<range>(?<start>\d+)\D+(?<end>\d+))
# 	RESULT = "Found a range $$+{range} that goes from $$+{start} to $$+{end}"
# 	MATCHED = $(shell $(call apply_perl_regex,file_from_20070101_to_20101231.txt,$(REGEX),$(RESULT)))
# 	$(info $(MATCHED))
# 	# Found a range 20070101_to_20101231 that goes from 20070101 to 20101231
# 
define apply_perl_regex
echo '$(1)' | perl -ne '@M=m/$(2)/xg;print($(3))'
endef

# :code:`match_perl_regex`
# ++++++++++++++++++++++++
#
# .. code:: makefile
# 
# 	$(shell $(call match_perl_regex,STRING,REGEX,RESULT))
# 
# STRING - string
# 	the string to match :code:`REGEX` against
# REGEX - Perl regular expression
# 	the regex to match. This regex has to contain *named* regex groups
# 	:perl:`(?<name>...)`.
# 
# Function to match a Perl REGEX on a STRING and and define Make variables named
# like the named regex groups and holding the matched content. This is
# particularly handy for conveniently extracting parts of strings. Keep in mind
# that for each named group, one subshell is spawned. This is not very
# efficient.
# 
# .. code:: makefile
# 
# 	REGEX = (?<range>(?<start>\d+)\D+(?<end>\d+))
# 	$(eval $(call match_perl_regex,file_from_20070101_to_20101231.txt,$(REGEX)))
# 	$(info Found a range $(range) that goes from $(start) to $(end))
# 	# Found a range 20070101_to_20101231 that goes from 20070101 to 20101231
# 
define match_perl_regex
_NAME_REGEX = \(\?<([a-zA-z]+)>
_PRINT_CMD = join(" ",@M)
_REGEX_NAMES = $$(shell $$(call apply_perl_regex,$(2),$$(_NAME_REGEX),$$(_PRINT_CMD)))
$$(foreach KEY,$$(_REGEX_NAMES),$$(eval $$(KEY) = $$(shell $$(call apply_perl_regex,$(1),$(2),$$$$+{$$(KEY)}))))
endef

