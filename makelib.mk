include tools.mk
export

# Entering/Leaving directory messages are annoying and not very useful
MAKEFLAGS += --no-print-directory

# This roundabout way of importing variables from 'developer-settings' works around the issue that
# gnumake will read in quotes from variables if `developer-settings` is included directly.
# e.g., var="val" will be read is as ["val"] instead of just [val]
$(shell env --ignore-environment - bash -c "source developer-settings && env" > /tmp/mkenv)
include /tmp/mkenv
export


export SUDO ?= sudo --preserve-env
export BASH ?= bash
export PYTHON ?= python3
export GO ?= $(GO_TOOL)
export OCTOPUS ?= $(OCTOPUS_TOOL)


ifdef DEBUG
export BASH += -x
export OCTOPUS += -v
endif

# Text style definitions ...
# no style
NON=\e[0m
# colors ...
RED=\e[31m
GRN=\e[32m
ORG=\e[33m
BLU=\e[34m
# bold
BLD=\e[1m
# italic
ITL=\e[3m
# style usages ...
CMD=$(RED)
FIL=$(GRN)
TGT=$(ORG)
DIR=$(BLU)
HDR=$(BLD)
ENV=$(BLD)
VAL=$(BLD)

# help target allows self-documenting makefiles
%.help:
# 'bash -c' interprets text format env vars (e.g., '${RED}')
# 'echo -e' renders colored text
# sed chooses all lines beginning with '##'
# sed puts all-caps header lines in bold
# sed puts all target lines in orange (targets are 3 spaces indented)
# sed escapes double quotes with a forward slash for echo
	@ bash -c "echo -e \"$$( \
	    sed -n -e 's/^##//p' $* | \
	    sed -e 's/^ \([A-Z /]\+\)$$/ $${HDR}\1$${NON}/' | \
			sed -e 's/^   \([A-Za-z.-]\+\)\(.*\)/   $${TGT}\1$${NON}\2/' | \
			sed -e 's/\"/\\\"/g' \
	  )\""
	@ echo ''
