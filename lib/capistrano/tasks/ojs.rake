def download_ojs(version_no, download_location)
  ojs_version = "ojs-#{version_no}"
  ojs_tar_file = "#{ojs_version}.tar"
  download_url = "http://pkp.sfu.ca/ojs/download/#{ojs_tar_file}.gz"

  execute :wget, download_url
  execute :gunzip, "#{ojs_tar_file}.gz"
  execute :tar, "-xvf #{ojs_tar_file}"
  execute :mv, "#{ojs_version} #{download_location}/"
  execute :rm, "#{ojs_tar_file}"
  
end
