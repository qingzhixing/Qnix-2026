QEMU = qemu-system-i386

# CCFLAGS
CCFLAGS += -fno-pic
CCFLAGS += -static
CCFLAGS += -fno-builtin
CCFLAGS += -fno-strict-aliasing
CCFLAGS += -O2
CCFLAGS += -Wall
CCFLAGS += -MD
CCFLAGS += -ggdb
CCFLAGS += -m32
CCFLAGS += -fno-omit-frame-pointer
CCFLAGS += -fno-stack-protector

SRC_DIR = ./src/
BUILD_DIR = ./build/

bootblock: $(SRC_DIR)boot_asm.S $(SRC_DIR)boot_main.cpp
	mkdir -p $(BUILD_DIR)
	g++ $(CCFLAGS) -I $(SRC_DIR) -c $(SRC_DIR)boot_main.cpp -o $(BUILD_DIR)boot_main.o
	g++ $(CCFLAGS) -I $(SRC_DIR) -c $(SRC_DIR)boot_asm.S -o $(BUILD_DIR)boot_asm.o
	ld -m elf_i386 -N -e start -Ttext 0x7C00 -o $(BUILD_DIR)bootblock.o $(BUILD_DIR)boot_asm.o $(BUILD_DIR)boot_main.o
	objdump -S $(BUILD_DIR)bootblock.o > $(BUILD_DIR)bootblock.asm
	objcopy -S -O binary -j .text $(BUILD_DIR)bootblock.o $(BUILD_DIR)bootblock.text
	./src/boot_block_sign.py -i $(BUILD_DIR)bootblock.text -o $(BUILD_DIR)bootblock

.PHONY: clean qemu

clean:
	rm -rf $(BUILD_DIR)

qemu: bootblock
	$(QEMU) -fda $(BUILD_DIR)bootblock
