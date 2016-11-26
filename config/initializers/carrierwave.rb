CarrierWave.configure do |config|
  if Rails.env.test? or Rails.env.cucumber? or Rails.env.development?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'] ,
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                 => ENV['AWS_REGION']
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
