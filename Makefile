CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
CFLAGS = -O0 -g -fno-builtin
LDFLAGS = -T linker.ld -nostdlib -static

OBJS = main.o uart.o print.o startup.o

TARGET = kernel.elf
BIN = kernel.bin

all: $(BIN)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJS)

$(BIN): $(TARGET)
	$(OBJCOPY) -O binary $(TARGET) $(BIN)

clean:
	rm -f *.o $(TARGET) $(BIN)
