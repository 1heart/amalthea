CC = g++

# compiler flags:
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
CFLAGS  = -g -Wall

# the build target executable:
TARGET = lapmain

all: lapmain

lapmain:
	$(CC) lapmain.cpp system.cpp lap.cpp -o lapmain

clean:
	if [ -a lapmain ] ; \
	  then \
	  rm lapmain; \
	  fi;
