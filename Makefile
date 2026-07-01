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
PROGRAMS = $(patsubst src/%.m4,$(OUTPUT)/%.mlog,$(wildcard src/*.m4) $(wildcard src/*/*.m4)) \
		   $(OUTPUT)/power/graph-small.mlog \
		   $(OUTPUT)/power/graph-large.mlog

### General Targets ###
.PHONY: all clean

.DELETE_ON_ERROR:

all: $(PROGRAMS)

clean:
	rm -rf $(OUTPUT)

$(OUTPUT)/%.mlog: src/%.m4
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) $< > $@


### Additional Include Dependencies ###
include/scope.m4: include/comptime.m4
	@touch $@

include/communication/remote-connect.m4: include/scope.m4 include/units.m4
	@touch $@

include/algorithms/memory.m4: include/scope.m4
	@touch $@

include/control-flow.m4: include/scope.m4
	@touch $@

include/graphics/borders.m4: include/graphics/layout.m4
	@touch $@

include/graphics/graphs.m4: include/comptime.m4 \
							include/scope.m4 \
							include/control-flow.m4 \
							include/graphics/layout.m4
	@touch $@

include/power/graph.m4: include/scope.m4 \
						include/control-flow.m4 \
						include/algorithms/memory.m4 \
						include/graphics/layout.m4 \
						include/graphics/borders.m4 \
						include/graphics/graphs.m4
	@touch $@


### Additional Template Dependencies ###
templates/power/graph-worker.m4: include/power/graph.m4
	@touch $@

templates/power/graph-leader.m4: include/comptime.m4 \
									include/scope.m4 \
									include/power/graph.m4
	@touch $@


### Additional Program Dependencies ###
$(OUTPUT)/transport/export.mlog: include/control-flow.m4

$(OUTPUT)/power/SCRAM.mlog: include/control-flow.m4


### Custom Targets ###
$(OUTPUT)/power/graph-small.mlog: templates/power/graph-leader.m4 \
									$(OUTPUT)/power/graph-small-worker1.mlog \
									$(OUTPUT)/power/graph-small-worker2.mlog \
									$(OUTPUT)/power/graph-small-worker3.mlog
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) \
		-DTEMPLATE_WORKERS=processor1,processor2,processor3	\
		-DTEMPLATE_CONFIG=POWER_GRAPH_LOGIC_DISPLAY \
		$< > $@

$(OUTPUT)/power/graph-small-worker%.mlog: templates/power/graph-worker.m4
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) \
		-DTEMPLATE_WORKER=$*	\
		-DTEMPLATE_CONFIG=POWER_GRAPH_LOGIC_DISPLAY \
		$< > $@

$(OUTPUT)/power/graph-large.mlog: templates/power/graph-leader.m4 \
									$(OUTPUT)/power/graph-large-worker1.mlog \
									$(OUTPUT)/power/graph-large-worker2.mlog \
									$(OUTPUT)/power/graph-large-worker3.mlog \
									$(OUTPUT)/power/graph-large-worker4.mlog \
									$(OUTPUT)/power/graph-large-worker5.mlog
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) \
		-DTEMPLATE_WORKERS=processor1,processor2,processor3,processor4,processor5	\
		-DTEMPLATE_CONFIG=POWER_GRAPH_LARGE_DISPLAY \
		$< > $@

$(OUTPUT)/power/graph-large-worker%.mlog: templates/power/graph-worker.m4
	@mkdir --parents $(@D)
	$(M4) $(M4FLAGS) $(patsubst %,-I %,$(INCLUDES)) \
		-DTEMPLATE_WORKER=$*	\
		-DTEMPLATE_CONFIG=POWER_GRAPH_LARGE_DISPLAY \
		$< > $@
