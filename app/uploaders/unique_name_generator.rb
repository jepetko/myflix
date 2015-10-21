module UniqueNameGenerator

  def filename
    "#{[original_filename_base, mounted_as, self.class.name, generate_unique_name].join('__')}#{original_filename_ext}" unless original_filename.nil?
  end

  private

  def original_filename_base
    File.basename(original_filename, File.extname(original_filename)) unless original_filename.nil?
  end

  def original_filename_ext
    File.extname(original_filename) unless original_filename.nil?
  end

  def generate_unique_name
    uuid = :"@#{mounted_as}_uuid"
    model.instance_variable_get(uuid) || model.instance_variable_set(uuid, SecureRandom.uuid)
  end

end