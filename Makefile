CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
CFLAGS = -O0 -g -fno-builtin -nostdlib -nostdinc -Iinclude
ASFLAGS = -O0 -g -Iinclude
LDFLAGS = -T linker.ld
NAME = kernel


TARGET = $(NAME).elf
BIN = $(NAME).bin

SRC_DIR = src
BUILD_DIR = build

C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
ASM_SOURCES = $(wildcard $(SRC_DIR)/*.S)

OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) \
          $(patsubst $(SRC_DIR)/%.S,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

all: $(BIN)

$(TARGET): $(OBJECTS)
#	$(CC) $(CFLAGS) -o $@ $(OBJECTS)
	$(LD) $(LDFLAGS) -Map $(NAME).map -o $(TARGET) $(OBJECTS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S | $(BUILD_DIR)
	$(CC) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN): $(TARGET)
	$(OBJCOPY) -O binary $(TARGET) $(BIN)

clean:
	rm -rf $(BUILD_DIR) $(TARGET) $(BIN)
