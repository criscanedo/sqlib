
CC := g++
LIBC := ar rsv
INCLUDE := -I include
CPPFLAGS := -c -Wall

srcdir := src
objdir := build
bindir := bin
incdir := include
testdir := tests
libdir := lib

LIB := $(libdir)//libdatabase.a
SRCS := $(wildcard $(srcdir)//*.cpp)
OBJS := $(patsubst $(srcdir)//%.cpp, $(objdir)//%.o, $(SRCS))

sqlite: $(srcdir)//sqlite3.c
	gcc -g $(INCLUDE) $(CPPFLAGS) -o $(objdir)//sqlite3.o $< -static

lib: $(LIB)

$(LIB): $(OBJS) $(objdir)//sqlite3.o
	$(LIBC) $@ $^
	@echo Compilation success

$(objdir)//%.o: $(srcdir)//%.cpp
	$(CC) -g $(INCLUDE) $(CPPFLAGS) -o $@ $<


# Run Tests

tbuilddir := $(testdir)\build
TESTSRCS := $(wildcard $(testdir)//*.cpp)
TESTOBJS := $(patsubst $(testdir)//%.cpp, $(tbuilddir)//%.o, $(TESTSRCS))
TESTEXE := $(testdir)//runtests


tests: $(TESTOBJS)
	$(CC) $^ -L $(bindir)//static -l cf -o $(TESTEXE)

$(tbuilddir)//%.o: $(testdir)//%.cpp
	$(CC) -I ..//$(incdir) $(CPPFLAGS) -o $@ $<

.PHONY: clean
clean:
	@echo Cleaning object files
	rm -rf $(objdir)//*.o
