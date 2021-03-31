set :branch, ENV["BRANCH"] || "main"

server 'localhost', roles: %w{app}
