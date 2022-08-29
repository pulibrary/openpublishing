# openpublishing
OJS instance for Princeton Open Access Publishing Platform

## Local Development
1. [Install docker](https://docs.docker.com/get-docker/)
1. [Install lando](https://docs.lando.dev/basics/installation.html)
1. Clone this repo: `git clone git@github.com:pulibrary/openpublishing.git`
1. `cd openpublishing`
1. `bundle install` to install required ruby gems
1. Download OJS: `rake download_ojs`
1. Start the application: `lando start`
1. See what port lando is running on: `lando info`

  Lando will start two docker containers: one with a PostgreSQL database and one with a PHP enabled web server. `lando info` will print out `APPSERVER URLS` that can be used to access the website. The will look something like `http://localhost:62226` but the port number may change. You should be able to visit that URL in a web browser and see the OJS application.

1. Visit OJS in your browser. You will be prompted to install OJS. You will need to provide login and password for an initial OJS admin user, plus database credentials:
  1. Database driver: PostgreSQL
  1. Host: database
  1. Username: postgres
  1. Password: **blank**
  1. Database name: lamp

1. Finally, login with the credentials you provided during installation.

## PUL OJS instances

PUL maintains two instances of OJS: ojs-staging, and ojs-prod. <https://openpublishing.princeton.edu> is an alias for ojs-prod.  See [configuration management documentation](/docs/configuration_management.md) for information about how these environments are used.

## Deployment

OJS deployments are handled in [princeton_ansible](https://github.com/pulibrary/princeton_ansible).  There is currently an [ojs_staging playbook](#) and an [ojs_prod playbook](#).  Points to remember when deploying OJS with ansible:

* The OJS core code base is downloaded from [the PKP OJS .tar.gz downloads](https://pkp.sfu.ca/ojs/ojs_download/).  The software version number is defined in ansible.
* Some core files are maintained in the PKP OJS repository as git submodules, and therefore do not automatically ship with OJS downloads from source.  [This is an example of our recommendated approach for pulling in submodule code](https://github.com/pulibrary/princeton_ansible/blob/main/roles/ojs/tasks/main.yml#L182).
* The healthSciences theme is downloaded from the [healthSciences theme PKP GitHub repository](https://github.com/pkp/healthSciences/).
* Custom CSS used with OJS themes are maintained in the [ojs_styles repository](https://github.com/pulibrary/ojs_styles).  These stylesheets are uploaded directly to OJS via the admin web UI (see the [ojs_styles README](https://github.com/pulibrary/ojs_styles#readme) for instructions).
