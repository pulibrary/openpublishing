set :branch, ENV["BRANCH"] || "main"

server "openpublishing-prod", user: fetch(:user), roles: %w{app}
