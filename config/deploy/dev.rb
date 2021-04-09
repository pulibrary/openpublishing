set :branch, ENV["BRANCH"] || "main"

#server "ojs-dev1", user: fetch(:user), roles: %w{app}

server 'ojs-dev1', roles: %w{app}
