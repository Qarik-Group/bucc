#!/bin/bash

source $(dirname $0)/common.sh

prepare_vars_file_for_cpi
set_default_cpi_flags

./bucc/bin/bucc down --cpi $(cpi)
