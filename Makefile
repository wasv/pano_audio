VSOURCE          = src/top.v

O               ?= $(CURDIR)/build
TOPLEVEL        ?= top
TARGET_PART     ?= xc6slx100-fgg484-2

CONSTRAINTS     ?= res/pano.ucf

include res/ise.mk

.PHONY: clean
clean:
	rm -r $O

.DEFAULT_GOAL := $(BITFILE)
