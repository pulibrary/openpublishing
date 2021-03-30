# openpublishing
OJS instance for Princeton Open Access Publishing Platform

## Local Development
1. [Install docker](https://docs.docker.com/get-docker/)
2. [Install lando](https://docs.lando.dev/basics/installation.html)
3. Clone this repo: `git clone git@github.com:pulibrary/openpublishing.git`
4. Start the application: `lando start`

Lando will start two docker containers: one with a PostgreSQL database and one with a PHP enabled web server. When it starts, lando will print out `APPSERVER URLS` that can be used to access the website. The will look something like `http://localhost:62226` but the port number may change. You should be able to visit that URL in a web browser and see the OJS application.
