FROM docker.hobot.cc/aitools/eval:py2-py3-centos7.5

WORKDIR /app
ENV VENV /app/venv
# ENV LANG C.UTF-8
# ENV LC_ALL C.UTF-8
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV PYTHONPATH /app

# Run this before dealing with our own virtualenv. The AWS CLI uses its own virtual environment
RUN pip3 install awscli -i https://pypi.douban.com/simple

# Set up a virtual environment to use with our workflows
RUN python3 -m venv ${VENV}
RUN ${VENV}/bin/pip install wheel -i https://pypi.douban.com/simple

COPY ./requirements.txt .
RUN ${VENV}/bin/pip install -r requirements.txt -i https://pypi.douban.com/simple

# This is a script that enables a virtualenv, copy it to a better location
RUN cp ${VENV}/bin/flytekit_venv /opt/

# Copy the rest of the code
COPY . .

# Set this environment variable. It will be used by the flytekit SDK during the registration/compilation steps
ARG IMAGE_TAG
ENV FLYTE_INTERNAL_IMAGE "docker.hobot.cc/aitools/$IMAGE_TAG"

# Enable the virtualenv for this image. Note this relies on the VENV variable we've set in this image.
ENTRYPOINT ["/opt/flytekit_venv"]
