#!/usr/bin/make -f

# Function to return an executable shell command that:
#  - gives the FIRST string argument to Perl
#  - matches the SECOND Perl-regex-like (with /x modifier) argument on it
#  - evaluates and prints the THIRD Perl-code-like argument
#  this is handy for back-reference with the Perl variables $1 to $9 or $+{key}
define apply_perl_regex
echo '$(1)' | perl -ne '@M=m/$(2)/xg;print($(3))'
endef

# Function to match a Perl regex (first argument) on a string (second argument)
# and define MAKE VARIABLES named like the NAMED REGEX GROUPS and holding the
# MATCHED CONTENT.
# This is particularly handy for extracting parts of strings.
# Keep in mind that for each named group, ONE subshell is spawned. This is not
# very efficient.
define match_perl_regex
_NAME_REGEX = \(\?<([a-zA-z]+)>
_PRINT_CMD = join(" ",@M)
_REGEX_NAMES = $$(shell $$(call apply_perl_regex,$(1),$$(_NAME_REGEX),$$(_PRINT_CMD)))
$$(foreach KEY,$$(_REGEX_NAMES),$$(eval $$(KEY) = $$(shell $$(call apply_perl_regex,$(2),$(1),$$$$+{$$(KEY)}))))
endef

