##	gluon site.mk makefile

##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	advancedstats \
	autoupdater \
	config-mode-statistics \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-tunneldigger \
	radvd \
	respondd \
	rfkill-disable \
	ssid-changer \
	status-page \
	tunneldigger-watchdog \
	web-advanced \
	web-private-wifi \
	web-wizard


##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/OpenWrt packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags
GLUON_SITE_PACKAGES := \
	ffho-autoupdater-wifi-fallback \
	gluon-alfred \
	haveged \
	iptables \
	iwinfo

GLUON_PRIORITY ?= 3
GLUON_LANGS ?= de
GLUON_ATH10K_MESH := ibss
GLUON_REGION ?= eu
