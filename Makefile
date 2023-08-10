# Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Original Author: Shay Gal-on
# Adapted for the Tandy Color Computer port by Boisy Pitre on Aug-15-23
#
# Make sure the default target is to simply build and run the benchmark.
RSTAMP = v1.0

PORT_DIR=coco
vpath %.c $(PORT_DIR)
vpath %.h $(PORT_DIR)
vpath %.mak $(PORT_DIR)
include $(PORT_DIR)/core_portme.mak

ITERATIONS=1
ifdef REBUILD
FORCE_REBUILD=force_rebuild
endif

CFLAGS += -DITERATIONS=$(ITERATIONS)

CORE_FILES = core_list_join core_main core_matrix core_state core_util
ORIG_SRCS = $(addsuffix .c,$(CORE_FILES))
SRCS = $(ORIG_SRCS) $(PORT_SRCS)
OBJS = $(addprefix $(OPATH),$(addsuffix $(OEXT),$(CORE_FILES)) $(PORT_OBJS))
OUTNAME = COREMARK$(EXE)
OUTFILE = $(OPATH)$(OUTNAME)
LOUTCMD = $(OFLAG) $(OUTFILE) $(LFLAGS_END)
OUTCMD = $(OUTFLAG) $(OUTFILE) $(LFLAGS_END)

HEADERS = coremark.h 
CHECK_FILES = $(ORIG_SRCS) $(HEADERS)

.PHONY: compile link
ifdef SEPARATE_COMPILE

$(OPATH)$(PORT_DIR):
	$(MKDIR) $(OPATH)$(PORT_DIR)

compile: $(OPATH) $(OPATH)$(PORT_DIR) $(OBJS) $(HEADERS) 

link: compile 
	$(LD) $(LFLAGS) $(XLFLAGS) $(LOUTCMD) $(OBJS)
	
else

compile: $(SRCS) $(HEADERS) 
	$(CC) $(CFLAGS) $(XCFLAGS) $(OUTCMD) $(SRCS)

link: compile 
	@echo "Link performed along with compile"

endif

$(OUTFILE): $(SRCS) $(HEADERS) Makefile core_portme.mak $(EXTRA_DEPENDS) $(FORCE_REBUILD)
	$(MAKE) port_prebuild
	$(MAKE) link
	$(MAKE) port_postbuild

PARAM1=$(PORT_PARAMS) 0x0 0x0 0x66 $(ITERATIONS)
PARAM2=$(PORT_PARAMS) 0x3415 0x3415 0x66 $(ITERATIONS)
PARAM3=$(PORT_PARAMS) 8 8 8 $(ITERATIONS)

run1.log-PARAM=$(PARAM1) 7 1 2000
run2.log-PARAM=$(PARAM2) 7 1 2000 
run3.log-PARAM=$(PARAM3) 7 1 1200

run1.log run2.log run3.log: load
	$(MAKE) port_prerun
	$(RUN) $(OUTFILE) $($(@)-PARAM) > $(OPATH)$@
	$(MAKE) port_postrun
	
.PHONY: gen_pgo_data
gen_pgo_data: run3.log

.PHONY: load
load: $(OUTFILE)
	$(MAKE) port_preload
	$(LOAD) $(OUTFILE)
	$(MAKE) port_postload

.PHONY: clean
clean:
	rm -f $(OUTFILE) $(OBJS) $(OPATH)*.log *.info $(OPATH)index.html $(PORT_CLEAN) *.dsk

dsk: compile
	decb dskini coremark.dsk
	echo "10 LOADM\"COREMARK\":EXEC" >/tmp/basic
	decb copy -0 -b -t /tmp/basic coremark.dsk,\*.BAS
	decb copy -2 -b $(OUTFILE) coremark.dsk,
	
.PHONY: force_rebuild
force_rebuild:
	echo "Forcing Rebuild"
	
.PHONY: check
check:
	md5sum -c coremark.md5 

