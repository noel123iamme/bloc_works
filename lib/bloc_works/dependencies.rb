class Object
  def self.const_missing(const)
  	controller_file = BlocWorks.snake_case(const.to_s)
  	if file_exists?(controller_file) then
	    require controller_file
	    if Object.const_defined? const then 
		    Object.const_get(const)
		  end
	  end
  end

  def file_exists?(file)
  	File.file? File.join("app", "controllers", "#{file}.rb") #"#{Dir.pwd}/app/controllers/#{file}.rb"
  end
end


