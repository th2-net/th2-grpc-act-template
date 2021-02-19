FROM gradle:6.6-jdk11 as java_generator
ARG nexus_url
ARG nexus_user
ARG nexus_password
ARG python_app_name

WORKDIR /home/project

COPY ./ .
RUN ./gradlew clean build publish \
    -Pnexus_url=${nexus_url} \
    -Pnexus_user=${nexus_user} \
    -Pnexus_password=${nexus_password}

FROM ghcr.io/th2-net/th2-python-service-generator:1.1.1 as python_service_generator
WORKDIR /home/project
COPY ./ .

RUN /home/service/bin/service -p src/main/proto/$python_app_name -w PythonServiceWriter -o src/gen/main/python/$python_app_name

FROM python:3.8-slim as python_generator
ARG pypi_repository_url
ARG pypi_user
ARG pypi_password

WORKDIR /home/project
COPY --from=python_service_generator /home/project .
RUN pip install -r requirements.txt && \
    pip install twine && \
    python setup.py generate && \
    python setup.py sdist && \
    twine upload --repository-url ${pypi_repository_url} --username ${pypi_user} --password ${pypi_password} dist/*
