set :branch, ENV["BRANCH"] || "main"

#server "openpublishing-staging", user: fetch(:user), roles: %w{app}

server 'localhost', roles: %w{app}
