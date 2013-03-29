def storage_config
  path = File.join(Rails.root.to_s, 'config/filesystem.yml')
  unless File.file?(path)
    return nil
  end

  config = YAML::load(ERB.new(File.read(path)).result)
  unless Hash === config
    return nil
  end

  config = config[Rails.env.to_s]
  unless Hash === config
    return nil
  end

  config
end



#
#  Configuration types
#
def configure_s3(config, s3)
  config.storage = :fog
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'uploads'

  credentials = {
    provider: 'AWS',
    aws_access_key_id: s3['access_key_id'],
    aws_secret_access_key: s3['secret_access_key'],
    region: 'eu-west-1'
  }

  if s3['vhost']
    config.asset_host = "http://#{s3['vhost']}"
  end

  config.fog_credentials = credentials
  config.fog_directory = s3['vhost'] || s3['bucket']
end


def configure_filesystem(config)
  config.storage = :file
end



#
#  Carrier Wave configuration block
#
CarrierWave.configure do |config|
  s3 = storage_config

  if s3
    configure_s3(config, s3)
  else
    configure_filesystem(config)
  end
end
