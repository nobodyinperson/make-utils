make-utils 
==========

.. image:: https://travis-ci.org/nobodyinperson/make-utils.svg?branch=master
    :target: https://travis-ci.org/nobodyinperson/make-utils

Makefile utilities

How to use
++++++++++

To use these functions, clone the repo or download the files and `include` them
into your ``Makefile``, e.g. with this code snippet:

.. code:: makefile

    MAKE_UTILS_PATH = make-utils # relative path to make-utils repo folder
    MAKE_UTILS_INCLUDES = $(wildcard $(realpath $(MAKE_UTILS_PATH))/*.mk) #* find function files
    include $(MAKE_UTILS_INCLUDES) # include the files

Tests
+++++

To run tests, run

.. code:: sh

    make test

