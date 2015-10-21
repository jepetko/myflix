module UniqueNameGenerator

  def filename
    [File.basename(original_filename, File.extname(original_filename)), mounted_as, self.class.name, generate_unique_name].join('__') unless original_filename.nil?
  end

  private
  def generate_unique_name
    uuid = :"@#{mounted_as}_uuid"
    model.instance_variable_get(uuid) || model.instance_variable_set(uuid, SecureRandom.uuid)
  end

end