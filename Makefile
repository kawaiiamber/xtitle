OUT = xtitle
VERCMD  ?= git describe --tags 2> /dev/null
VERSION := $(shell $(VERCMD) || cat VERSION)

CPPFLAGS += -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"
CFLAGS   += -std=c99 -pedantic -Wall -Wextra
LDLIBS   := -lm -lxcb -lxcb-icccm -lxcb-ewmh

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man

SRC := $(wildcard *.c)
OBJ := $(SRC:.c=.o)

all: $(OUT)

debug: CFLAGS += -O0 -g
debug: $(OUT)

include Sourcedeps

$(OBJ): Makefile

install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -p $(OUT) "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)"/man1
	cp -p "doc/xtitle.1" "$(DESTDIR)$(MANPREFIX)/man1"

uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)"/$(OUT)
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/xtitle.1

clean:
	rm -f $(OUT) $(OBJ)

.PHONY: all debug install uninstall clean
