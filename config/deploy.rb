# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "openpublishing"
set :repo_url, "git@github.com:kelynch/openpublishing.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/openpublishing"
set :shared_path, "/var/local"

set :user, "deploy"

namespace :ojs do

  set :ojs_root, "#{fetch(:deploy_to)}/ojs"
  set :ojs_file_uploads, File.join(fetch(:shared_path), 'files')

  desc "Create shared files directory"
  task :prepare_shared_paths do
    on release_roles :app do
      unless test("[ -d #{File.join(fetch(:ojs_file_uploads))} ]")
        execute :mkdir, fetch(:ojs_file_uploads)
      end
      execute :mkdir, '-p', fetch(:ojs_file_uploads)
      execute :chmod,  " -R 775 #{fetch(:ojs_file_uploads)}"

      info "Created file uploads directory link"
    end
  end

  desc "Link shared OJS files"
  task :link_config do
    on roles(:app) do |host|
      execute "cd #{release_path}/ojs && ln -sf #{fetch(:shared_path)}/config.inc.php config.inc.php"
      info "linked config inc PHP file to current release"
    end
  end

end

namespace :deploy do

  desc "Set file system directories and linked files"
  task :after_deploy_check do
    invoke "ojs:prepare_shared_paths"
    invoke "ojs:link_config"
  end

end
