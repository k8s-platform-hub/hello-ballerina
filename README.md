# hello-ballerina

A hello-world application using [Ballerina](https://ballerina.io/), The cloud native programming language.

## What does this come with

- Boilerplate code, configuration for:
  - Ballerina runtime setup
  - Ready to go Dockerfile with a hello-world service

### Deployment instructions

### Basic deployment:

* Press the **Clone & Deploy** button above and follow the instructions.
   * The `hasura quickstart` command clones the project repository to your local system and also creates a **free Hasura cluster** where the project will be hosted for free.
   * A git remote (called hasura) is created and initialized with your project directory.
   * `git push hasura master` builds and deploys the project to the created Hasura cluster.
   * The Ballerina service is deployed as a microservice called **app** with the context **/hello/sayHello**.
   * Run the below command to open your app:
``` shell
 $ hasura microservice open app --path hello/sayHello
```

### Making changes to your source code and deploying

* To make changes to the app, browse to `/microservices/app/src` and edit the Ballerina files according to your requirements.
* Commit the changes, and run `git push hasura master` to deploy the changes.


## Adding backend features

This section will help you bootstrap some backend features using Hasura. If you want to continue vanilla Ballerina development, you can skip this section.

Hasura makes it easy to add backend features to your python apps.
- Add auth using an inbuilt UI or APIs for username, email-verification, mobile-otp, social login.
- Integrate with the database easily.
  -  Use data APIs from Ballerina to query postgres without an ORM
  -  Or use data APIs directly from the client-side code
- Add file upload/download features using Hasura's file APIs with customisable permissions to configure sharing

You can use Hasura APIs from your client side javascript directly, or from your Ballerina code. Read more about Hasura [data](https://hasura.io/features/data), [auth](https://hasura.io/features/auth) & [filestore](https://hasura.io/features/filestore) APIs. They are powerful and can help you save a lot of time and code when building out your applications.

### API console

Hasura gives you a web UI to manage your database and users. You can also explore the Hasura APIs and automatically generate API code in the language of your choice.

#### Run this command inside the project directory

```bash
$ hasura api-console
```
![api-explorer.png](https://filestore.hasura.io/v1/file/463f07f7-299d-455e-a6f8-ff2599ca8402)


## View server logs

If the push fails with an error `Updating deployment failed`, or the URL is showing `502 Bad Gateway`/`504 Gateway Timeout`,
follow the instruction on the page and checkout the logs to see what is going wrong with the microservice:

```bash
# see status of microservice app
$ hasura microservice list

# get logs for app
$ hasura microservice logs app
```

## Adding dependencies

### Add a Ballerina dependency

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

### Add a system dependency

The base image used in this boilerplate is [ballerina/ballerina-platform:0.971.0](https://hub.docker.com/r/ballerina/ballerina-platform/), which is based on Alpine Linux.
You can add a package by mentioning it in the `Dockerfile`, by using the `apk` tool.

## Deploying your existing Ballerina app

Read this section if you already have a Ballerina app and want to deploy it on Hasura.

- Replace the contents of `src/` directory with your own app's Ballerina files.
- Leave `k8s.yaml`, and `Dockerfile` as it is.
- If there are any Ballerina dependencies, add and configure them in `Dockerfile` (see [above](#add-a-ballerina-dependency)).
- If there are any system dependencies, add and configure them in `Dockerfile` (see [above](#add-a-system-dependency)).

## Local development

Running your Ballerina code locally works as it usually would. 

### Handling dependencies on other microservices
Your Ballerina app will at some point depend on other microservices like the database,
or Hasura APIs. In this case, when you're developing locally, you'll have to change your
the endpoints you're using. Ideally, you can use an environment variable to switch between
'DEVELOPMENT' or 'PRODUCTION' mode and use different endpoints.

This is something that you're already probably familiar with if you've worked with databases
before.

#### Ballerina app running on the cluster (after deployment)
Example endpoints:
```
if system:getEnv("PRODUCTION") {
  postgres = "postgres.hasura:5432"
  dataUrl  = "data.hasura:80"
}
```

#### Ballerina app running locally (during dev or testing)
Example endpoints:
```
if system:getEnv("DEVELOPMENT") {
  postgres = "localhost:5432"
  dataUrl  = "localhost:9000"
}
```

And in the background, you will have to expose your Hasura microservices on these ports locally:

```bash
# Access postgres locally
$ hasura microservice port-forward postgres -n hasura --local-port 5432


# Access Hasura data APIs locally
$ hasura microservice port-forward data -n hasura --local-port 9000
```

