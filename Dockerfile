FROM alpine
MAINTAINER Rafael Ladislau <rafael.ladislau@nyu.edu>
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
    
RUN pip3 install jupyterhub flask

RUN apk add --no-cache uwsgi uwsgi-python3

# application folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 9095

# copy config files into filesystem
COPY app.py /usr/src/app/app.py

# exectute start up script
ENTRYPOINT [ "uwsgi", "--http-socket", "0.0.0.0:9095", "--uid", "uwsgi", "--plugins", "python3", "--protocol", "uwsgi", "--mount", "/usr/src/app/=app:app" ]
