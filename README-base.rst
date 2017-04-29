.. role:: bash(code)
   :language: bash


make-utils 
==========

.. image:: https://travis-ci.org/nobodyinperson/make-utils.svg?branch=master
    :target: https://travis-ci.org/nobodyinperson/make-utils

Makefile utilities

How to use
++++++++++

To use the functions ``make-utils`` provides, make sure to make it available to
your ``Makefile``. To do so, you may either:

- add ``make-utils`` somewhere as a git submodule - if you are using git 
  anyway - with 
  :bash:`git submodule add https://github.com/nobodyinperson/make-utils` 
  (elegant way) 
- clone this repo somewhere with 
  :bash:`git clone https://github.com/nobodyinperson/make-utils` 
  (semi-elegant way)
- download the :bash:`*.mk`-files directly and put they in some folder 
  (crude way)

Then include ``make-utils`` into your ``Makefile``. Something along this should
do it:

.. code:: makefile

    # relative path to the make-utils repo folder or whereever you put the .mk-files
    MAKE_UTILS_PATH = make-utils 
    MAKE_UTILS_INCLUDES = $(wildcard $(realpath $(MAKE_UTILS_PATH))/*.mk) #*.mk-files
    include $(MAKE_UTILS_INCLUDES) # include the files

Tests
+++++

To run tests, run

.. code:: sh

    make test

