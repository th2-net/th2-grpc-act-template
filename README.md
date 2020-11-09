# gRPC Act Template Library

This tool generates code from `.proto` files and upload constructed packages (`.proto` files and generated code) to specified repositories.

## How to use:
1. Create a directory with the name same as project name (replace dashes with underscores) under `src/main/proto` directory (remove other files and directories if they exist).
2. Place your own `.proto` files in created directory. Pay attention to `package` specifier and `import` statements.
3. Edit paths in `python_service_generator` stage in Dockerfile.
4. Edit `rootProject.name` variable in `settings.gradle` file. This will be the name of Java package.
5. Edit parameters of `setup.py` in `setup` function invocation such as: `author`, `author_email`, `url`. Do not edit the others.

Note that the name of created directory under `src/main/proto` directory is used in Python (it's a package name) and Docker (in `python_service_generator` stage), so it should be the same in all places.

### Parameters
- `IMAGE_NAME` - name of Docker image
- `IMAGE_VERSION` - version of Docker image
- `APP_VERSION` - version of Java package
- `ARTIFACTORY_USER` - user for Java artifactory
- `ARTIFACTORY_PASS` - password for Java artifactory
- `ARTIFACTORY_REPO` - repository for Java artifactory
- `ARTIFACTORY_URL` - URL for Java artifactory
- `NEXUS_URL` - URL for Nexus (Java)
- `NEXUS_USER` - user for Nexus (Java)
- `NEXUS_PASS` - password for Nexus (Java)
- `PYPI_REPOSITORY_URL` - URL for Python package repository
- `PYPI_USER` - user for Python package repository
- `PYPI_PASSWORD` - password for Python package repository
- `APP_NAME` - name of Python package
- `APP_VERSION` - version of Python package

### Docker
You can run everything via Docker:
```
docker build --tag {IMAGE_NAME}:{IMAGE_VERSION} . --build-arg release_version=${APP_VERSION}
                                                  --build-arg artifactory_user=${ARTIFACTORY_USER}
                                                  --build-arg artifactory_password=${ARTIFACTORY_PASS}
                                                  --build-arg artifactory_deploy_repo_key=${ARTIFACTORY_REPO}
                                                  --build-arg artifactory_url=${ARTIFACTORY_URL}
                                                  --build-arg pypi_repository_url=${PYPI_REPOSITORY_URL}
                                                  --build-arg nexus_url=${NEXUS_URL}
                                                  --build-arg nexus_user=${NEXUS_USER}
                                                  --build-arg nexus_password=${NEXUS_PASS}
                                                  --build-arg pypi_user=${PYPI_USER}
                                                  --build-arg pypi_password=${PYPI_PASSWORD}
                                                  --build-arg app_name=${APP_NAME}
                                                  --build-arg app_version=${APP_VERSION}
```
See [Parameters](#parameters) section.

### Java
If you wish to manually create and publish package for Java, run these command:
``` 
gradle --no-daemon clean build publish artifactoryPublish \
       -Prelease_version=${RELEASE_VERSION} \
       -Partifactory_user=${ARTIFACTORY_USER} \
       -Partifactory_password=${ARTIFACTORY_PASSWORD} \
       -Partifactory_deploy_repo_key=${ARTIFACTORY_DEPLOY_REPO_KEY} \
       -Partifactory_url=${ARTIFACTORY_URL} \
       -Pnexus_url=${NEXUS_URL} \
       -Pnexus_user=${NEXUS_USER} \
       -Pnexus_password=${NEXUS_PASSWORD}
```
See [Parameters](#parameters) section.

### Python
If you wish to manually create and publish package for Python:
1. Edit `package_info.json` file in order to specify name and version for package (create file if it's absent).
2. Run these commands:
```
pip install -r requirements.txt
python setup.py generate
python setup.py sdist
twine upload --repository-url ${PYPI_REPOSITORY_URL} --username ${PYPI_USER} --password ${PYPI_PASSWORD} dist/*
```
See [Parameters](#parameters) section.
