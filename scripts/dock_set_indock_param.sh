#!/bin/bash

# set a parameters in the INDOCK file


PARAMETER=$1
VALUE=$2


sed -e a: -e "s/${PARAMETER} \{1, 31\}${VALUE}/& /;ta"
