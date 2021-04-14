# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "openpublishing"
set :repo_url, "https://github.com/pulibrary/openpublishing.git"

set :branch, ENV['BRANCH'] if ENV['BRANCH']

set :deploy_to, "/home/deploy/ojs"

# Path for file uploads associated with OJS installation - from install instructions "It is strongly recommended that this directory be placed in a non-web-accessible location to ensure a secure environment (or otherwise protected from direct access, such as via .htaccess rules)"
set :shared_path, "/home/deploy/ojs/local"

set :ojs_root, "#{fetch(:deploy_to)}/html"

set :user, "deploy"

after :deploy, "ojs:copy_ojs_config"

namespace :ojs do

  set :ojs_file_uploads, File.join(fetch(:shared_path), 'files')
  set :ojs_prod_version, "3.3.0-4"

  desc "Copy ojs config file into place"
  task :copy_ojs_config do
    on roles :app do
      execute :cp, '-a', "#{fetch(:deploy_to)}/config.inc.php", "#{fetch(:deploy_to)}/html/ojs/"
      execute "sudo chown -R www-data:deploy #{fetch(:deploy_to)}/html/ojs/config.inc.php"
    end
  end

  desc "Download and unzip OJS version"
  task :download_and_setup do
    on roles :app do
      unless test("[ -d #{File.join(fetch(:ojs_root))} ]")
        execute :mkdir, fetch(:ojs_root)
      end

      # Initial download and setup of OJS
      download_ojs(fetch(:ojs_prod_version), fetch(:ojs_root))
      execute :ln, "-sfn", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}", "#{fetch(:ojs_root)}/ojs"

      # Update filesystem permissions according to OJS install instructions - https://openjournalsystems.com/ojs-3-user-guide/installation/
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/config.inc.php"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/public"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/cache"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/cache/t_cache"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/cache/t_config"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/cache/t_compile"
      execute "chmod 765 #{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/cache/_db"
    end
  end

  desc "Create shared files directory"
  task :prepare_shared_paths do
    on release_roles :app do
      unless test("[ -d #{File.join(fetch(:ojs_file_uploads))} ]")
        execute :mkdir, fetch(:ojs_file_uploads)
      end

      # Create shared filesystem path for uploads
      execute :mkdir, '-p', fetch(:ojs_file_uploads)
      execute :chmod,  " -R 775 #{fetch(:ojs_file_uploads)}"
      execute "sudo chown -R www-data:deploy #{fetch(:ojs_file_uploads)}"
      info "Created file uploads directory link"
    end
  end

end

namespace :setup do
  desc "Set file system directories and linked files"
  task :filesystem do
    invoke "ojs:prepare_shared_paths"
    invoke "ojs:download_and_setup"
  end
end

namespace :deploy do
  desc "Update themes from pulibrary/openpublishing"
  task :themes do
    on roles (:app) do
      invoke "deploy"
      execute :cp, '-a', "#{fetch(:deploy_to)}/current/plugins/themes/.", "#{fetch(:ojs_root)}/ojs/plugins/themes/"
      execute "sudo chown -R www-data:deploy #{fetch(:ojs_root)}"
    end
  end
end

namespace :upgrade do

  set :ojs_upgrade_version, "3.3.0-4"

  desc "Upgrade OJS"
  task :ojs do
    on roles(:app) do

      error "Upgrade version (#{fetch(:ojs_upgrade_version)}) lower than or same as current production version (#{fetch(:ojs_prod_version)})"; break if fetch(:ojs_upgrade_version) <= fetch(:ojs_prod_version)

      invoke "deploy"

      unless test("[ -d #{File.join("#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}-backup/")} ]")
        execute "sudo chown -R deploy:deploy #{fetch(:ojs_root)}"
        execute :mkdir, "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}-backup/"
      end

      unless test("[ -d #{File.join("#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_upgrade_version)}-hold/")} ]")
        execute :mkdir, "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_upgrade_version)}-hold/"
      end

      download_ojs(fetch(:ojs_upgrade_version), fetch(:ojs_root))

      # Make a copy of the upgrade config file
      execute :cp, "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_upgrade_version)}/config.inc.php", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_upgrade_version)}-hold/"

      # Move config and public files out of the current install
      execute :cp, "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/config.inc.php", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}-backup/"
      execute :cp, "-R", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}/public", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_prod_version)}-backup/"

      # Point OJS to the new version
      execute :ln, "-sfn", "#{fetch(:ojs_root)}/ojs-#{fetch(:ojs_upgrade_version)}", "#{fetch(:ojs_root)}/ojs"
      execute "sudo chown -R www-data:deploy #{fetch(:ojs_root)}"

    end
  end
end
