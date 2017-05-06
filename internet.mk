#!/usr/bin/make -f

# 
# .. role:: bash(code)
# 	:language: bash
#

# :code:`download_url_to_file`
# ++++++++++++++++++++++++++++
# 
# .. code:: makefile
# 
# 	SHELLCODE = $(call download_url_to_file,URL,FILE)
# 
# URL - string
# 	the url to download
# FILE - path
# 	the file to save the downloaded content to
# 
# Function to return an executable shell command that downloads URL and saves
# the content to FILE. Uses :bash:`wget`.
# 
# .. code:: makefile
# 	
# 	# generate shell command to download gnu.org webpage to gnu.html
# 	SHELLCODE = $(call download_url_to_file,gnu.org,gnu.html)
# 	$(info $(SHELLCODE))
# 	# wget -q -O gnu.html gnu.org 
# 	# download!
# 	$(shell $(SHELLCODE))
# 
define download_url_to_file
wget -q -O $(2) $(1)
endef

