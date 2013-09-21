VER  := $(shell git describe)

DIRS := \
	/etc/rc.d \
	/etc/rc.d/functions.d \
	/etc/logrotate.d \
	/etc/profile.d \
	/usr/lib/initscripts \
	/usr/lib/tmpfiles.d \
	/usr/bin \
	/usr/share/bash-completion/completions \
	/usr/share/zsh/site-functions \
	/usr/share/man/man5 \
	/usr/share/man/man8

CONFIGS := \
	conf/inittab \
	conf/rc.conf

SCRIPTS := \
	scripts/rc.local \
	scripts/rc.local.shutdown \
	scripts/rc.multi \
	scripts/rc.shutdown \
	scripts/rc.single \
	scripts/rc.sysinit

DAEMONS := \
	daemon/hwclock \
	daemon/network \
	daemon/netfs

MAN_PAGES := \
	man/rc.conf.5 \
	man/rc.d.8 \

TOOLS := \
	tools/arch-binfmt \
	tools/arch-modules \
	tools/arch-tmpfiles

all: doc

installdirs:
	install -dm755 $(foreach DIR, $(DIRS), $(DESTDIR)$(DIR))

install: installdirs doc
	install -m644 -t $(DESTDIR)/etc $(CONFIGS)
	install -m755 -t $(DESTDIR)/etc $(SCRIPTS)
	install -m644 -t $(DESTDIR)/etc/logrotate.d misc/bootlog
	install -m644 -t $(DESTDIR)/etc/rc.d scripts/functions
	install -m755 -t $(DESTDIR)/etc/rc.d $(DAEMONS)
	install -m755 -t $(DESTDIR)/usr/bin tools/rc.d
	install -m755 -t $(DESTDIR)/etc/profile.d misc/read_locale.sh
	install -m644 -t $(DESTDIR)/usr/share/man/man5 $(filter %.5, $(MAN_PAGES))
	install -m644 -t $(DESTDIR)/usr/share/man/man8 $(filter %.8, $(MAN_PAGES))
	install -m755 -t $(DESTDIR)/usr/lib/initscripts $(TOOLS)
	install -m644 conf/tmpfiles.conf $(DESTDIR)/usr/lib/tmpfiles.d/initscripts.conf
	install -m644 -T completions/bash-completion $(DESTDIR)/usr/share/bash-completion/completions/rc.d
	install -m644 -T completions/zsh-completion $(DESTDIR)/usr/share/zsh/site-functions/_rc.d

%.5: %.5.txt
	a2x -d manpage -f manpage $<

%.8: %.8.txt
	a2x -d manpage -f manpage $<

doc: $(MAN_PAGES)

clean:
	rm -f $(MAN_PAGES)

.PHONY: all installdirs install doc clean
