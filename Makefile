include ../adrf-hub/makefiles/helm.mk ../adrf-hub/makefiles/hub_k8s.mk
include ./makefiles/configmap.mk
include ./makefiles/docker.mk

# Prepare environment to developer system
prepare:
	[ ! -d "../adrf-hub" ] && cd .. && git clone https://github.com/NYU-CI/adrf-hub.git -b master && cd ./adrf-hub && make prepare-hub
