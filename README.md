# th2 gRPC act template library

This is the template project for creating custom gRPC act libraries. It contains proto messages and `Act` service that are used [th2 act template](https://github.com/th2-net/th2-act-template-j "th2-act-template-j"). See [act_template.proto](src/main/proto/th2_grpc_act_template/act_template.proto "act_template.proto") file for details. <br>
Tool generates code from `.proto` files and uploads built packages (`.proto` files and generated code) to specified repositories.

## How to transform template
1. Create a directory with the same name as project name (use underscores instead of dashes) under `src/main/proto` directory (remove other files and directories if they exist).
2. Place your custom `.proto` files in created directory. Pay attention to `package` specifier and `import` statements.
3. Edit `release_version` and `vcs_url` properties in `gradle.properties` file.
4. Edit `rootProject.name` variable in `settings.gradle` file. This will be the name of Java package.
5. Edit `package_info.json` file in order to specify name and version for Python package (create file if it's absent).
6. Edit parameters of `setup.py` in `setup` function invocation such as: `author`, `author_email`, `url`. Do not edit the others.

Note that the name of created directory under `src/main/proto` directory is used in Python (it's a package name).

## How to maintain project
1. Make your changes.
2. Up version of Java package in `gradle.properties` file.
3. Up version of Python package in `package_info.json` file.
4. Commit everything.

## How to run project
### Java
If you wish to manually create and publish package for Java, run these command:
```
gradle --no-daemon clean build publish artifactoryPublish \
       -Pbintray_user=${BINTRAY_USER} \
       -Pbintray_key=${BINTRAY_KEY}
```
`BINTRAY_USER` and `BINTRAY_KEY` are parameters for publishing.

### Python
If you wish to manually create and publish package for Python:
1. Generate services from `.proto` files:
    - Download and build [th2 Python service generator](https://github.com/th2-net/th2-python-service-generator "th2-python-service-generator") project with Gradle:
        ```
        gradle clean build
        ```
    - Run th2 Python service generator:
        ```
        java -jar {path_to_jar} -p src/main/proto/{package_name} -w PythonServiceWriter -o src/gen/main/python/{package_name}
       ```
2. Generate code from `.proto` files and publish everything:
    ```
    pip install -r requirements.txt
    python setup.py generate
    python setup.py sdist
    twine upload --repository-url ${PYPI_REPOSITORY_URL} --username ${PYPI_USER} --password ${PYPI_PASSWORD} dist/*
    ```
    `PYPI_REPOSITORY_URL`, `PYPI_USER` and `PYPI_PASSWORD` are parameters for publishing.
