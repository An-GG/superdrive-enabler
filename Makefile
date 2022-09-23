COMPILER=clang++-15

# todo: object files into output path, processing c / c++ files in the same time (?), nested directories for source files (?)
C = c
OUTPUT_PATH = dist/
SOURCE_PATH = src/
EXE = $(OUTPUT_PATH)superdrive-enabler

ifeq ($(COMPILER), G++)
  ifeq ($(OS),Windows_NT)
    OBJ = obj
  else
    OBJ = o
  endif
  COPT = -O2
  CCMD = g++
  OBJFLAG = -o
  EXEFLAG = -o
# INCLUDES = -I../.includes
  INCLUDES =
# LIBS = -lgc
  LIBS =
# LIBPATH = -L../gc/.libs
  LIBPATH =
  CPPFLAGS = $(COPT) -g $(INCLUDES)
  LDFLAGS = $(LIBPATH) -g $(LIBS)
  DEP = dep
else
  OBJ = obj
  COPT = -O2
  CCMD = clang++-15
  OBJFLAG = -o
  EXEFLAG = -o
# INCLUDES = /I..\\.includes
  INCLUDES =
# LIBS = ..\\.libs\\libgc.lib
  LIBS =
  CPPFLAGS = $(COPT) $(INCLUDES)
  LDFLAGS =
endif

OBJS := $(patsubst %.$(C),%.$(OBJ),$(wildcard $(SOURCE_PATH)*.$(C)))

%.$(OBJ):%.$(C)
	@echo Compiling $(basename $<)...
	$(CCMD) -c $(CPPFLAGS) $(CXXFLAGS) $< $(OBJFLAG)$@

all: $(OBJS)
	@echo Linking $(OBJS)...
	$(CCMD) $(LDFLAGS) $^ $(LIBS) $(EXEFLAG) $(EXE)

clean:
	rm -rf $(SOURCE_PATH)*.$(OBJ) $(EXE)

rebuild: clean all


UDEV_RULE = /etc/udev/rules.d/99-superdrive.rules
LOCAL_BIN = /usr/local/bin/superdrive-enabler

install: 
	@echo Linking bin to ~/.local/bin
	$(eval F := $(LOCAL_BIN))
	if [ -L $(F) ]; then echo "\n >>>>  this symlink already exists\n"; else ln -s $(CURDIR)/dist/superdrive-enabler $(F); fi
	@echo Copying udev rule, to /etc/udev/rules.d
	$(eval F := $(UDEV_RULE))
	if [ -L $(F) ]; then echo "\n >>>>  this symlink already exists\n"; else cp $(CURDIR)/99-superdrive.rules $(F); fi

uninstall: 
	@echo Deleting udev rule...
	$(eval F := $(UDEV_RULE))
	if [ -L $(F) ]; then rm $(F); else echo "\n >>>>  no symlink at $(F)\n"; fi
	@echo Unlinking bin from ~/.local/bin
	$(eval F := $(LOCAL_BIN)) 
	if [ -L $(F) ]; then rm $(F); else echo "\n >>>>  no symlink at $(F)\n"; fi

autoreinstall: uninstall rebuild install
