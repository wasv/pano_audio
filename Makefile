VSOURCE          = src/top.v

O               ?= $(CURDIR)/build
TOPLEVEL        ?= top
TARGET_PART     ?= xc6slx100-fgg484-2

CONSTRAINTS     ?= res/pano.ucf

ISE_PATH        ?= /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64
BITFILE         ?= $O/project.bit

COMMON_OPTS     ?= -intstyle xflow
XST_OPTS        ?=
NGDBUILD_OPTS   ?=
MAP_OPTS        ?=
PAR_OPTS        ?=
BITGEN_OPTS     ?=
TRACE_OPTS      ?=
FUSE_OPTS       ?= -incremental

.DEFAULT_GOAL := $(BITFILE)
.PHONY: clean
.SILENT:

RUN = cd $O && $(ISE_PATH)/$1

$O/project.prj: $(VSOURCE)
	@mkdir -p $(@D)
	@rm -f $@
	$(foreach file,$(VSOURCE),echo "verilog work \"$(CURDIR)/$(file)\"" >> $@;)
	$(foreach file,$(VHDSOURCE),echo "vhdl work \"$(CURDIR)/$(file)\"" >> $@;)

$O/project.scr:
	@mkdir -p $(@D)
	@rm -f $@
	@echo "run" \
	    -ifn $O/project.prj \
	    -ofn $O/project.ngc \
	    -ifmt mixed \
	    $(XST_OPTS) \
	    -top $(TOPLEVEL) \
	    -ofmt NGC \
	    -p $(TARGET_PART) \
	    > $@

$O/project.ngc: $O/project.scr $O/project.prj
	@mkdir -p $(@D)
	$(call RUN,xst) $(COMMON_OPTS) \
		-ifn $<

$O/project.pcf: $O/project.ngd

$O/project.ngd: $O/project.ngc $(CONSTRAINTS)
	@mkdir -p $(@D)
	$(call RUN,ngdbuild) $(COMMON_OPTS) $(NGDBUILD_OPTS) \
	    -p $(TARGET_PART) -uc $(CURDIR)/$(CONSTRAINTS) \
	    $< $$@

$O/project.map.ncd: $O/project.ngd $O/project.pcf
	@mkdir -p $(@D)
	$(call RUN,map) $(COMMON_OPTS) $(MAP_OPTS) \
	    -p $(TARGET_PART) \
	    -w $< -o $@ project.pcf

$O/project.ncd: $O/project.map.ncd $O/project.pcf
	@mkdir -p $(@D)
	$(call RUN,par) $(COMMON_OPTS) $(PAR_OPTS) \
	    -w $< $@ project.pcf

$(BITFILE): $O/project.ncd
	@mkdir -p $(@D)
	$(call RUN,bitgen) $(COMMON_OPTS) $(BITGEN_OPTS) \
	    -w $< $@
	@echo "Bitfile done."

clean:
	rm -r $O
