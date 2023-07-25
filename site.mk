##	gluon site.mk makefile

GLUON_DEPRECATED := upgrade

##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	autoupdater \
	config-mode-domain-select \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-tunneldigger \
	respondd \
	rfkill-disable \
	ssid-changer \
	status-page \
	web-advanced \
	web-private-wifi \
	web-wizard

##	GLUON_MULTIDOMAIN
#		Build gluon with multidomain support.

GLUON_MULTIDOMAIN=1

##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/OpenWrt packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags
GLUON_SITE_PACKAGES := \
	ffho-autoupdater-wifi-fallback \
	gluon-alfred \
	iptables \
	iwinfo

GLUON_PRIORITY ?= 3
GLUON_LANGS ?= de
GLUON_REGION ?= eu
