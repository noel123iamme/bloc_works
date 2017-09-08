require "erubis"
 
module BlocWorks
  class Controller
    def initialize(env)
      @env = env
    end

    def render(view, locals = {})
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      if File.file? filename then
	      template = File.read(filename)
	    else
	    	template = "view not found: #{view}"
	    end

      # puts "instanc variables: #{self.instance_variables}"
      attribs = Hash[self.instance_variables.map{ |var| 
        ["#{var.to_s}", self.instance_variable_get(var.to_s)] 
      }]
      # should have been this...
      # self.instance_variables.each do |var|
      #   locals[var] = self.instance_variable_get(var)
      # end
      # puts "attribs: #{attribs}"

      eruby = Erubis::Eruby.new(template)
      eruby.result(locals.merge(attribs))
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      BlocWorks.snake_case(klass)
    end
  end
end

