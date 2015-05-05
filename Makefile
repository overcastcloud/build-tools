#!/usr/bin/make -f

export DEBDESTDIR=$(PWD)/pool
ifeq ($(REBUILD),1)
NOCLEAN=-nc
endif

all: overcast-monolith pool/Packages

overcast-monolith: pool
	test -n "$(BUILD_NUMBER)" || (echo '$$BUILD_NUMBER must be set' ; exit 1)
	cd $@ ; dpkg-buildpackage -b $(NOCLEAN) --changes-option=-u$(DEBDESTDIR)

pool:
	test -d pool || mkdir pool

pool/Packages: pool
	cd pool ; apt-ftparchive packages . > Packages

clean:
	rm pool/* || true
	fakeroot debian/rules clean

.PHONY: pool/Packages overcast-monolith
