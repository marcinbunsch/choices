require 'hashie/mash'
require 'erb'

module Choices
  extend self
  
  def load_settings(filename, env)
    mash = Hashie::Mash.new(load_settings_hash(filename, env))
    
    with_local_settings(filename, env, '.local') do |local|
      mash.update local
    end
    
    return mash
  end
  
  def load_settings_hash(filename, env)
    yaml_content = ERB.new(IO.read(filename)).result
    YAML::load(yaml_content)[env]
  end
  
  def with_local_settings(filename, env, suffix)
    local_filename = filename.sub(/(\.\w+)?$/, "#{suffix}\\1")
    if File.exists? local_filename
      hash = load_settings_hash(local_filename, env)
      yield hash if hash
    end
  end
end

if defined? Rails
  require 'choices/rails'
end
