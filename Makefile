USRNAME ?= $(shell bash -c 'read -p \
  "The Octave Savannah CVS repository is checked out to the parent directory.  Savannah login: " usr; \
	echo $$usr')

SAVANNAH_DIR := ../octave

CVS_RSH=ssh

export CVS_RSH

CHECK_GEM := $(shell command -v gem 2> /dev/null)
CHECK_JEKYLL := $(shell command -v jekyll 2> /dev/null)
CHECK_JEKYLL_VERSION = $(shell jekyll --version | grep ^jekyll | sed 's/^.* //g')

deploy: | $(SAVANNAH_DIR) check_prerequisites
	#
	# Build static website into the subdirectory `_site` using Jekyll
	#
	jekyll build
	#
	# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	# DANGAROUS STEP, ommitted by default.
	#
	# Remove all previous files in the target directory, but no directories at
	# all or CVS related stuff.  This is due to a limitation of CVS, see
	#
	#   https://web.archive.org/web/20140629054602/http://ximbiot.com/cvs/manual/cvs-1.11.23/cvs_7.html#SEC69
	#
	# For some introduction to CVS, see https://savannah.nongnu.org/projects/cvs
	# or http://www.cs.umb.edu/~srevilak/cvs.html.
	#
	# find $(SAVANNAH_DIR) -type f -not -path "*/CVS/*" -exec rm -f '{}' \;
	#
	# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	#
	# Copy the content of that directory `_site` into the checked out
	# Savannah CVS (see make target $(SAVANNAH_DIR)).
	#
	cp -a _site/. $(SAVANNAH_DIR)
	#
	# Add all potential new directories to CVS
	#
	cd $(SAVANNAH_DIR) && find . -type d -not -name "CVS" -exec cvs add '{}' \;
	#
	# Add all potential new files to CVS (the following command taken from
	# http://stackoverflow.com/questions/5071/how-to-add-cvs-directories-recursively
	# proved to be fast)
	#
	cd $(SAVANNAH_DIR) && find . -type f | grep -v CVS | xargs cvs add
	#
	# Commit the chages to get online.
	#
	cd $(SAVANNAH_DIR) && cvs commit
	#
	# Now everything should be visible to the world.
	#

check_prerequisites:
ifndef CHECK_GEM
	$(error "Command `gem` is not available please install rubygems")
endif
ifndef CHECK_JEKYLL
	$(error "Command `jekyll` is not available. ${CHECK_JEKYLL_VERSION}  Try `gem install jekyll`")
endif
ifneq "3.3" "$(word 1, $(sort 3.3 $(CHECK_JEKYLL_VERSION)))"
	$(error "Detected Jekyll version ${CHECK_JEKYLL_VERSION} (>= 3.3 required).")
endif
	@echo "All prerequisites fulfilled."

$(SAVANNAH_DIR):
	cd .. \
	&& cvs -z3 -d:ext:$(USRNAME)@cvs.savannah.gnu.org:/web/octave checkout -P octave

.DEFAULT_GOAL :=