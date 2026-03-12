CC = cc
CFLAGS = -O2 -Wall -Wextra
LDLIBS = -lX11 -lXinerama
PREFIX ?= /usr/local

TARGET = get-monitor-x
SRC = get-monitor-x.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(LDLIBS)

install: $(TARGET)
	mkdir -p $(PREFIX)/bin
	cp $(TARGET) $(PREFIX)/bin
	chmod 711 $(PREFIX)/bin/$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all clean install

