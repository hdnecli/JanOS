ASM = nasm
BUILD = build

all: os-image

$(BUILD)/boot.bin: bootloader/boot.asm
	mkdir -p $(BUILD)
	$(ASM) -f bin $< -o $@

os-image: $(BUILD)/boot.bin
	cp $(BUILD)/boot.bin $(BUILD)/os.img

run: os-image
	qemu-system-x86_64 -drive format=raw,file=$(BUILD)/os.img

clean:
	rm -rf $(BUILD)
