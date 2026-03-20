### Variables ###
# command to process m4 files
M4 = m4

# flags to use when processing m4 files
M4FLAGS = --fatal-warnings

# directories to be added to the m4 include search path
INCLUDES = include

# directory containing build artifacts
OUTPUT = build

# list of programs to build by default
PROGRAMS = $(patsubst src/%.m4,$(OUTPUT)/%.mlog,$(wildcard src/*.m4) $(wildcard src/*/*.m4))


### General Targets ###
.PHONY: all clean

all: $(PROGRAMS)

clean:
	rm -rf $(OUTPUT)

$(OUTPUT)/%.mlog: src/%.m4
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) $< > $@


### Additional Include Dependencies ###
include/communication/remote-connect.m4: include/scope.m4 include/units.m4
	@touch $@

include/algorithms/memory.m4: include/scope.m4
	@touch $@

include/control-flow.m4: include/scope.m4
	@touch $@

### Additional Program Dependencies ###
