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
      eruby = Erubis::Eruby.new(template)
      eruby.result(locals.merge(env: @env))
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      BlocWorks.snake_case(klass)
    end
  end
end

