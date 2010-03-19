class Configuration < ActiveRecord::Base
  def self.get(key)
    c = find_by_config_key(key)
    return c.config_value unless c.nil?
    nil
  end
  
  def self.save(upload)
    name =  'institute_logo.jpg'
    directory = "public/uploads/image"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
end