# hello-ballerina

Boilerplate for a [Ballerina](https://ballerina.io/) microservice.

## Add a Ballerina dependency

In order to use new Ballerina packages in your app, you can install the packages locally first using the **ballerina pull <pkg_name>** command. This is only required if you are running Ballerina source files (.bal), where as, if you are using .balx files (binary executables), the dependencies will have been already statically linked into the .balx file. 

Ballerina packages can be seached from the shell using the command **ballerina search <key_word>**;
e.g.:-
```bash
$ ballerina search gmail

Ballerina Central
=================

|NAME             | DESCRIPTION                     | DATE           | VERSION | 
|-----------------| --------------------------------| ---------------| --------| 
|wso2/gmail       | Connects to Gmail from Baller...| 2018-05-14-Mon | 0.9.0   | 
|erandig/gconta...| Connects to Google Contacts f...| 2018-05-01-Tue | 0.6.0   | 
|madawa/gmail     | Connects to Gmail from Baller...| 2018-05-02-Wed | 0.8.12  | 
|dushaniw/gdrive3 | Connects to Google Drive from...| 2018-05-02-Wed | 0.3.0   | 

```

In order use new Ballerina package in your app, add a `CMD` section to the `Dockerfile` to execute a **ballerina pull** command.

```
# Dockerfile:

FROM ballerina/ballerina-platform:0.971.0
# copy the source code
COPY src /home/ballerina
# install the dependencies
CMD ["ballerina", "pull", "wso2/gmail"]
# run the executable
CMD ["ballerina", "run", "hello_service.bal"]

```

## Add a system dependency

The base image used in this boilerplate is [ballerina/ballerina-platform:0.971.0](https://hub.docker.com/r/ballerina/ballerina-platform/), which is based on Alpine Linux.
You can add a package by mentioning it in the `Dockerfile`, by using the `apk` tool.

## Deploying your existing Ballerina app

Read this section if you already have a Ballerina app and want to deploy it on Hasura.

- Replace the contents of `src/` directory with your own app's Ballerina files.
- Leave `k8s.yaml`, and `Dockerfile` as it is.
- If there are any Ballerina dependencies, add and configure them in `Dockerfile` (see [above](#add-a-ballerina-dependency)).
- If there are any system dependencies, add and configure them in `Dockerfile` (see [above](#add-a-system-dependency)).

## Debug

If the push fails with an error `Updating deployment failed`, or the URL is showing `502 Bad Gateway`/`504 Gateway Timeout`,
follow the instruction on the page and checkout the logs to see what is going wrong with the microservice:

```bash
# see status of microservice app
$ hasura microservice list

# get logs for app
$ hasura microservice logs app
```

## Local development

With Hasura's easy and fast git-push-to-deploy feature, you hardly need to run your code locally.
However, you can follow the steps below in case you have to run the code in your local machine.

### Without Docker

```bash
# go to app directory
$ cd microservices/app

# install dependencies
$ ballerina pull <package_name>

# run the Ballerina app
$ ballerina run src/hello_service.bal
```

Go to [http://localhost:9090/hello/sayHello](http://localhost:9090/hello/sayHello) using your browser to see the development version on the app.
Once you've made any required changes and tested locally, you can [deploy them to Hasura cluster](#deploy).

### With Docker

Install [Docker CE](https://docs.docker.com/engine/installation/) and cd to app directory:

```bash
# go to app directory
$ cd microservices/app

# build the docker image
$ docker build -t hello-ballerina-app .

# run the image with port bindings
$ docker run -p 9090:9090 hello-ballerina-app

# service will be available at `http://localhost:9090/hello/sayHello`
# press Ctrl+C to stop the running container
```

For any change you make to the source code, you will have to stop the container, build the image again and run a new container.
