# GRPC Generator Template

## Current supported languages: Java, Python
Fork this project and follow instructions.

This tool generates code from `.proto` files and upload constructed packages (`.proto` files with generated code) to desired repositories.

### How to use:
1. Edit `rootProject.name` variable in `settings.gradle file`. This will be the name of Java package.
2. Edit `package_name` variable in `setup.py`. This will be the name of Python package. <br>
You can also edit parameters of `setup.py` in `setup` function invocation such as: `url`, `author`, `author_email`, `description`. <br> 
Do not edit the others.
3. Create a directory with the name `package_name` (as in Python) under `src/main/proto` directory (remove example files `Foo.proto` and `Bar.proto` if present).
4. Place your own `.proto` files in created directory.
5. Edit imports in your `.proto` files so that they look like <br>
`import "{package_name}/{proto_file_name}.proto"`
6. Edit paths in `python-service-generator` stage in Dockerfile. They should correspond to the project structure.

#### Docker
You can run everything via Docker:
```
docker build --tag {IMAGE_NAME}:{IMAGE_VERSION} . --build-arg release_version=${APP_VERSION}
                                                  --build-arg artifactory_user=${ARTIFACTORY_USER}
                                                  --build-arg artifactory_password=${ARTIFACTORY_PASS}
                                                  --build-arg artifactory_deploy_repo_key=${ARTIFACTORY_REPO}
                                                  --build-arg artifactory_url=${ARTIFACTORY_URL}
                                                  --build-arg pypi_repository_url=${PYPI_REPOSITORY_URL}
                                                  --build-arg pypi_user=${PYPI_USER}
                                                  --build-arg pypi_password=${PYPI_PASSWORD}
                                                  --build-arg app_version=${APP_VERSION}
```
Parameters:
- `IMAGE_NAME` - name of Docker image
- `IMAGE_VERSION` - version of Docker image
- `APP_VERSION` - version of Java package
- `ARTIFACTORY_USER` - user for Java artifactory
- `ARTIFACTORY_PASS` - password for Java artifactory
- `ARTIFACTORY_REPO` - repository for Java artifactory
- `ARTIFACTORY_URL` - URL for Java artifactory
- `PYPI_REPOSITORY_URL` - URL for Python package repository
- `PYPI_USER` - user for Python package repository
- `PYPI_PASSWORD` - password for Python package repository
- `APP_VERSION` - version of Python package

#### Java:
If you wish to manually create and publish package, run these command:
``` 
gradle --no-daemon clean build artifactoryPublish \
       -Prelease_version=${release_version} \
       -Partifactory_user=${artifactory_user} \
       -Partifactory_password=${artifactory_password} \
       -Partifactory_deploy_repo_key=${artifactory_deploy_repo_key} \
       -Partifactory_url=${artifactory_url}
```
`release_version` is the version of resulting package and `artifactory_user`, `artifactory_password`, `artifactory_deploy_repo_key`, `artifactory_url` are parameters of artifactory.

#### Python
If you wish to manually create and publish package then you should:
1. Edit `version.info` file in order to specify package version (create file if it's absent)
2. Run these commands:
```
pip install -r requirements.txt
python setup.py generate
python setup.py sdist
twine upload --repository-url ${pypi_repository_url} --username ${pypi_user} --password ${pypi_password} dist/*
```
`pypi_repository_url`, `pypi_user`, `pypi_password` are parameters of package repository. 