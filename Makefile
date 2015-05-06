#!/usr/bin/make -f

ifeq ($(NOCLEAN),1)
NOCLEAN_ARG=-nc
endif

SUBDIRS=overcast-monolith contrail

local: $(patsubst %,local-%,$(SUBDIRS)) pool/Packages

source: $(patsubst %,source-%,$(SUBDIRS))

local-%: pool %
	cd $* ; DEBDESTDIR=$(PWD)/pool dpkg-buildpackage -b $(NOCLEAN_ARG) --changes-option=-u$(PWD)/pool -uc -us

source-%:
	cd $* ; dpkg-buildpackage -S $(NOCLEAN_ARG) -uc -us

source-contrail:
	cd contrail; make -f packages.make source-package-contrail KEYID='"" -uc -us'

pool:
	test -d pool || mkdir pool

pool/Packages: pool
	cd pool ; apt-ftparchive packages . > Packages

clean:
	rm pool/* || true
	fakeroot debian/rules clean

.PHONY: pool/Packages overcast-monolith $(patsubst %,%.local,$(SUBDIRS))
