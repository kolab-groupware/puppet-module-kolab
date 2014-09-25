MODULENAME	:= kolab

install:
	mkdir -p $(DESTDIR)/var/lib/puppet/modules/$(MODULENAME)
	(if [ -d "files/" ]; then cp -r files $(DESTDIR)/var/lib/puppet/modules/$(MODULENAME)/; fi)
	(if [ -d "lib/" ]; then cp -r lib $(DESTDIR)/var/lib/puppet/modules/$(MODULENAME)/; fi)
	(if [ -d "manifests/" ]; then cp -r manifests $(DESTDIR)/var/lib/puppet/modules/$(MODULENAME)/; fi)
	(if [ -d "templates/" ]; then cp -r templates $(DESTDIR)/var/lib/puppet/modules/$(MODULENAME)/; fi)
