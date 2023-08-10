
# Introduction

This is a version of the CoreMark benchmark utility for the Tandy Color Computer. Please refer to the [official CoreMark repository](https://github.com/eembc/coremark) for more details about history and other patforms.

# Building and Running

You'll need [CMOC 0.1.84](http://perso.b2b2c.ca/~sarrazip/dev/cmoc.html), [lwtools](http://lwtools.ca), and [ToolShed](https://github.com/n6il/toolshed/) installed on your system. This was ported and built on macOS -- your mileage may vary on other hosted platforms.
	
To build the benchmark in a ready-to-go disk image, type:

`make dsk`

You can use DriveWire or some other method to bring the resulting disk image over to a real CoCo or use an emulator. CoreMark results are output to the screen.
	
## Make Targets

* `compile` - compile the benchmark executable 
* `link` - link the benchmark executable
* `check` - test MD5 of sources that may not be modified
* `clean` - clean temporary files
* `dsk` - create a disk image named `COREMARK.DSK` with the `COREMARK.BIN` binary suitable to `LOADM` under Disk Extended Color BASIC.

## Benchmark Validity

CoreMark is set to run the benchmark for 1 iteration. The minimum required run time for a valid result is 10 seconds. So far, a stock CoCo takes around 28 seconds, so 1 iteration is fine.
