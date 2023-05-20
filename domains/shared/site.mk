##	gluon site.mk makefile 

##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	autoupdater \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-tunneldigger \
	radvd \
	respondd \
	status-page \
	web-advanced \
	web-wizard \
        web-private-wifi \
	advancedstats \
        config-mode-statistics \
	ssid-changer \
	tunneldigger-watchdog \
        rfkill-disable
##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/OpenWrt packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags
GLUON_SITE_PACKAGES := \
	haveged \
	iwinfo \
	iptables \
	gluon-alfred
#GLUON_SITE_PACKAGES := \
#        gluon-config-mode-autoupdater \
#	gluon-config-mode-contact-info \
#	gluon-config-mode-core \
#	gluon-config-mode-geo-location \
#	gluon-config-mode-hostname \
#	gluon-web-admin \
#	gluon-web-autoupdater \
#	gluon-web-network \
#	gluon-web-private-wifi \
#	gluon-web-wifi-config \
#	gluon-setup-mode \
#	gluon-mesh-vpn-core \
	
GLUON_PRIORITY ?= 3
GLUON_LANGS ?= de
GLUON_ATH10K_MESH := ibss
GLUON_REGION ?= eu
