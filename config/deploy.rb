# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "openpublishing"
set :repo_url, "git@github.com:pulibrary/openpublishing.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/openpublishing"

set :user, "deploy"
