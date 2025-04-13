# Tên file và thư mục
SRC_DIR = src
TB_DIR = tb
BUILD_DIR = build

# File nguồn và testbench
RADIX4BOOTH_SRC = $(SRC_DIR)/radix4booth.v
RADIX4BOOTH_TB = $(TB_DIR)/radix4booth_tb.v

RADIX4BOOTH_OPT_SRC = $(SRC_DIR)/radix4booth_opt.v
RADIX4BOOTH_OPT_TB = $(TB_DIR)/radix4booth_opt_tb.v

# Output file
RADIX4BOOTH_OUT = $(BUILD_DIR)/radix4booth.out
RADIX4BOOTH_OPT_OUT = $(BUILD_DIR)/radix4booth_opt.out

# Compiler flags
IVERILOG = iverilog
VVP = vvp

all: prepare radix4booth radix4booth_opt

prepare:
	mkdir -p $(BUILD_DIR)

radix4booth: $(RADIX4BOOTH_SRC) $(RADIX4BOOTH_TB)
	$(IVERILOG) -o $(RADIX4BOOTH_OUT) $(RADIX4BOOTH_SRC) $(RADIX4BOOTH_TB)
	$(VVP) $(RADIX4BOOTH_OUT)

radix4booth_opt: $(RADIX4BOOTH_OPT_SRC) $(RADIX4BOOTH_OPT_TB)
	$(IVERILOG) -o $(RADIX4BOOTH_OPT_OUT) $(RADIX4BOOTH_OPT_SRC) $(RADIX4BOOTH_OPT_TB)
	$(VVP) $(RADIX4BOOTH_OPT_OUT)

clean:
	rm -rf $(BUILD_DIR)
