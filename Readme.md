Custom CRF and questionnaire tool
===========================

A tool to build epidemiology addressed forms. 

## Build
The main target is to yield a WAR file, suitable to be deployed in, ideally any, WAR container.

The easiest way is import the project into an IDE (Jetbrains IntelliJ Idea recommended), configure and use the IDE capabilities to yield the WAR file.

A `build.xml` ant build file is provided with various targets to yield. So, you can take advantage of it and use the ant build file along with __ant tool__ to generate the WAR file.

## Deployment
Once the WAR file is generated, just drop it in the appropriate directory of you fave WAR container in order to make it work. 

Deployment was tested and working with __Apache Tomcat/6.0.35__, but it can be used with any WAR container, although you will may have to make changes to some proprietary configuration files in the container to accomodate the application.