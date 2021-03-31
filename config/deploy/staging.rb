set :branch, ENV["BRANCH"] || "main"

server "openpublishing-staging", user: fetch(:user), roles: %w{app}
