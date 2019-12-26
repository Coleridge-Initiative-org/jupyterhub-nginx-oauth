include ./makefiles/variables.mk

# Edit configmap and apply
configmap: edit-configmap-dev apply-configmap-dev 

# apply the configmap
apply-configmap-dev:
	kubectl -n workspace apply -f ../adrf-hub/helm/dev/jupyterhub-pod-config.yaml

# edit configmap file
edit-configmap-dev:
	sed -i -E 's/RELEASE_TAG_adrf-jupyterhub-nginx-oauth:.*/RELEASE_TAG_adrf-jupyterhub-nginx-oauth: ${FULLTAG}/g' ../adrf-hub/helm/dev/jupyterhub-pod-config.yaml
	sed -i -E 's/tag:.*\#JUPYTERHUB_NGINX_OAUTH_TAG/tag: ${FULLTAG} #JUPYTERHUB_NGINX_OAUTH_TAG/g' ../adrf-hub/helm/dev/config.yaml


# Edit configmap and apply
configmap-stg: edit-configmap-stg apply-configmap-stg 

# apply the configmap
apply-configmap-stg:
	kubectl -n workspace apply -f ../adrf-hub/helm/staging/jupyter-hub-configmap.yml

# edit configmap file
edit-configmap-stg:
	sed -i -E 's/RELEASE_TAG_adrf-jupyterhub-nginx-oauth:.*/RELEASE_TAG_adrf-jupyterhub-nginx-oauth: ${FULLTAG}/g' ../adrf-hub/helm/staging/jupyter-hub-configmap.yml
	sed -i -E 's/tag:.*\#JUPYTERHUB_NGINX_OAUTH_TAG/tag: ${FULLTAG} #JUPYTERHUB_NGINX_OAUTH_TAG/g' ../adrf-hub/helm/staging/config.yaml

# Edit configmap and apply
configmap-prod: edit-configmap-prod apply-configmap-prod 

# apply the configmap
apply-configmap-prod:
	kubectl -n workspace apply -f ../adrf-hub/helm/production/jupyter-hub-configmap.yml

# edit configmap file
edit-configmap-prod:
	sed -i -E 's/RELEASE_TAG_adrf-jupyterhub-nginx-oauth:.*/RELEASE_TAG_adrf-jupyterhub-nginx-oauth: ${FULLTAG}/g' ../adrf-hub/helm/production/jupyter-hub-configmap.yml
	sed -i -E 's/tag:.*\#JUPYTERHUB_NGINX_OAUTH_TAG/tag: ${FULLTAG} #JUPYTERHUB_NGINX_OAUTH_TAG/g' ../adrf-hub/helm/production/config.yaml
