set :branch, ENV["BRANCH"] || "main"

server "openpublishing-prod", user: fetch(:user), roles: %w{app}

#set :search_api_solr_host, 'lib-solr-staging.princeton.edu'
#set :search_api_solr_path, '/solr/recap-staging'
