# frozen_string_literal: true

desc 'Download and unzip OJS for local development'
task :download_ojs do
  puts "Downloading OJS for local development"
  download_ojs('3.3.0-4', '.')
end

def download_ojs(version_no, download_location)
  ojs_version = "ojs-#{version_no}"
  ojs_tar_file = "#{ojs_version}.tar"
  download_url = "http://pkp.sfu.ca/ojs/download/#{ojs_tar_file}.gz"

  `wget #{download_url}` unless File.exist? "#{ojs_tar_file}.gz"
  `gunzip #{ojs_tar_file}.gz`
  `tar -xvf #{ojs_tar_file}`
  `rm #{ojs_tar_file}`
  `ln -s #{ojs_version} ojs`
end
