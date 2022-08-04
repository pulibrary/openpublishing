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
PUL maintains two instances of OJS: ojs-staging, and ojs-prod. <https://openpublishing.princeton.edu> is an alias for ojs-prod.

Server installation follows this recipe:
1. Create a PUL ubuntu instance
2. Run an ansible playbook, like [this one](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/ojs_production.yml) to install PHP, apache, PostgreSQL, and to populate a configuration file that will contain the database credentials OJS needs.
3. Ensure there is a deploy target for the new environment in this repo, under `config/deploy/$ENV.rb`
4. Once you have a deploy target, make sure you're on the VPN and you have credentials set up to allow for passwordless ssh connections to the system. Then:
  1. `cap staging setup:filesystem`
  2. `cap staging deploy`
5. At this point OJS will be *almost* configured, but you will need to go to the newly setup instance in a browser and fill in the login and password of the first admin user manually.
6. Deploy the themes:
  1. `cap staging deploy:themes`.

  Note that there appear to be some bugs in OJS such that themes are not enabled automatically. You may need to manually enable a theme via the OJS UI before it will be accessible. You may need to use the UI to install a new theme before the PUL maintained themes show up in the UI.

## Deploying an updated theme
When there have been changes to the PUL maintained theme, deploy them like this:

1. Clone this repo: `git clone git@github.com:pulibrary/openpublishing.git`
1. `cd openpublishing`
1. `bundle install`
1. Run capistrano commands for setup and deployment:
  ```bash
  cap staging deploy:themes # deploy updated custom themes
  ```
  OPTIONAL: Supply a branch name as a command-line parameter, to run Capistrano commands on a specific branch on the remote, example:

  ```bash
  cap staging deploy:themes BRANCH=3-capistrano_deploy
  ```

## To upgrade the core OJS software:
TBD
