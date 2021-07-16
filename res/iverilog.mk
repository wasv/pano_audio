.PRECIOUS: $O/%.vvp
$O/%.vvp: $(VSOURCE_TEST)
	mkdir -p $(@D)
	iverilog -s $* -o $@ $^

%/Simulate $O/%.lx2: $O/%.vvp
	(cd $O && vvp $^ -lxt2 && mv dump.lx2 $*.lx2)
