json.array!(@university_infos) do |university_info|
  json.extract! university_info, :id, :address, :fullname, :email, :regdate, :site, :telephone, :worktime, :founder_address, :founder_director, :founder_email, :founder_site, :founder_phone, :founder_name, :infodate, :university_id
  json.url university_info_url(university_info, format: :json)
end
