VSOURCE          = src/top.v

VSOURCE_TEST     = $(VSOURCE)
VSOURCE_TEST    += src/top_tb.v

O               ?= $(CURDIR)/build
TOPLEVEL        ?= top
TARGET_PART     ?= xc6slx100-fgg484-2

CONSTRAINTS     ?= res/pano.ucf

include res/ise.mk
include res/iverilog.mk

.PHONY: clean
clean:
	rm -r $O

.DEFAULT_GOAL := $(BITFILE)
