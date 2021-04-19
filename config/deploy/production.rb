set :branch, ENV["BRANCH"] || "main"

server "ojs-prod1", roles: %w{app}
