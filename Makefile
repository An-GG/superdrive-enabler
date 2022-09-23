COMPILER=clang++-15

# todo: object files into output path, processing c / c++ files in the same time (?), nested directories for source files (?)
C = c
OUTPUT_PATH = out/production/superdrive-enabler/
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
  EXEFLAG = -e
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
	@echo $(LDFLAGS)
	@echo $(LIBS)
	@echo $(CPPFLAGS)
	@echo $(CXXFLAGS)
	@echo $(OBJFLAG)
	@echo Linking...
	$(CCMD) $(LDFLAGS) $^ $(LIBS) $(EXEFLAG) $(EXE)

clean:
	rm -rf $(SOURCE_PATH)*.$(OBJ) $(EXE)

rebuild: clean all
#rebuild is not entirely correct
