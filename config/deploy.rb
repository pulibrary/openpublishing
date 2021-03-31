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

  set :ojs_version_no, "3.3.0-4" #TODO make this a variable
  set :ojs_version, "ojs-#{fetch(:ojs_version_no)}"
  set :ojs_tar_file, "#{fetch(:ojs_version)}.tar"
  set :download_url, "http://pkp.sfu.ca/ojs/download/#{fetch(:ojs_tar_file)}.gz"

  set :ojs_root, "#{fetch(:deploy_to)}/html"
  set :ojs_file_uploads, File.join(fetch(:shared_path), 'files')

  desc "Download and unzip OJS version"
  task :setup do
    on roles :app do
      unless test("[ -d #{File.join(fetch(:ojs_root))} ]")
        execute :mkdir, fetch(:ojs_root)
      end

      within fetch(:deploy_to) do
        execute :wget, fetch(:download_url)
        execute :gunzip, "#{fetch(:ojs_tar_file)}.gz"
        execute :tar, "-xvf #{fetch(:ojs_tar_file)}"
        set :expanded_tar_dir, "#{fetch(:deploy_to)}/#{fetch(:ojs_version)}"
        execute :mv, "#{fetch(:expanded_tar_dir)} #{fetch(:ojs_root)}"
        execute :rm, "#{fetch(:ojs_tar_file)}"
      end

    end
  end

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
      execute "cd #{fetch(:ojs_root)}/#{fetch(:ojs_version)} && ln -sf #{fetch(:shared_path)}/config.inc.php config.inc.php"
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
