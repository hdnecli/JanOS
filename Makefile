ASM   = nasm
BUILD = build

all: os-image

$(BUILD)/boot.bin: bootloader/boot.asm
	mkdir -p $(BUILD)
	$(ASM) -f bin bootloader/boot.asm -o $(BUILD)/boot.bin

$(BUILD)/stage2.bin: bootloader/pm_entry.asm
	$(ASM) -f bin bootloader/pm_entry.asm -o $(BUILD)/stage2.bin

os-image: $(BUILD)/boot.bin $(BUILD)/stage2.bin
	cat $(BUILD)/boot.bin $(BUILD)/stage2.bin > $(BUILD)/os.img

run: os-image
	qemu-system-i386 -fda $(BUILD)/os.img

clean:
	rm -rf $(BUILD)

