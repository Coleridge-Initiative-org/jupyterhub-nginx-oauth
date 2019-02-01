# jupyterhub-nginx-oauth
Authenticate a JupyterHub Service running behind an Nginx using JHub Oauth features.

This project intends to give a way to authenticate JupyterHub Services/web applications running behind an nginx in the zero to jupyterhub project.

The documentation is explaining how you can authenticate a service replacing JupyterLab.

First, you will need to create the image and send it to a register (AWS ECR for example).

1. `docker build jupyter-nginx-oauth .`
2. `docker tag jupyter-nginx-oauth:latest <ECR_URL>`
3. `docker push <ECR_URL>`

The service running behind Nginx should have the following configuration (In this case every time a user logs in, he will have one instance of this service) (KubeSpawner will create a pod running the service container and will pass to this pod the JupyterHub environment variables):

```
auth_request /validate;

location = /validate {
    proxy_pass http://127.0.0.1:9095/validate;
    proxy_pass_request_body off; # no need to send the POST body
    proxy_set_header Content-Length "";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Original-URI $request_uri;
    # Our ingress configuration requires this proxy_redirect 
    proxy_redirect https,http https;
}

auth_request_set $auth_resp_state $upstream_http_x_auth_state;
auth_request_set $auth_resp_login_url $upstream_http_x_auth_login_url;

location = /oauth_callback {
    proxy_pass http://127.0.0.1:9095/oauth_callback;

    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    # WebSocket support
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_redirect https,http https;

}

error_page 401 = @error401;
location @error401 {
    add_header Set-Cookie ###REPLACE_WITH_THE_JUPYTERHUB_CLIENT_ID_ENVIRONMENT_VARIABLE###-oauth-state="$auth_resp_state";
    return 302 https://$host$auth_resp_login_url;
}
```


We want to make JupyterHUB sends the JupyterHub environment variables to the oauth container. So we need this configuration on the z2jh helm chart values:
```yaml
hub:
  extraConfig: |
    from kubespawner.spawner import KubeSpawner as KSO
    from tornado import gen
    class KubeSpawner(KSO):
        def get_pod_manifest(self):
            if self.extra_containers:
                for container in self.extra_containers:
                    if "name" in container and container["name"] == "jupyterhub-oauth":
                        container["env"] = [ {'name': k, 'value': v} for k, v in (self.get_env() or {}).items()]
            return super(KubeSpawner, self).get_pod_manifest()
    
  c.JupyterHub.spawner_class = KubeSpawner
``` 
 You also need an extra container running the jupyterhub-nginx-oauth image. Add this to the configuration:
  
 ```yaml
  hub:
    extraContainers: [{"name": "jupyterhub-oauth", "image": '<ECR_URL>', "ports": [{"containerPort": 9095, "name": "jhub-oauth", "protocol": "TCP"}]}]
 ```
  
  These configurations should be enough to run your service behind an nginx server with authentication
