require "bloc_works/version"
require "bloc_works/utility"
require "bloc_works/dependencies"
require "bloc_works/router"
require "bloc_works/controller"

module BlocWorks
  class Application
  	def call(env)
  		if env['PATH_INFO'] == '/favicon.ico'
				[404, {'Content-Type' => 'text/html'}, []]
  		else
	  		controller_class, action_name = self.controller_and_action(env)
	  		# puts "controller_class: #{controller_class}"
	  		if action_name == ""
	  			action_name = "index" 
	  		elsif action_name.nil?
	  			action_name = "index"
	  		end
	  		# puts "action_name: #{action_name}"
	  		if controller_class.nil? then
	  			[200, {'Content-Type' => 'text/html'}, ["Hello Blocheads!"]]
	  		elsif not controller_class.method_defined?("#{action_name}")
	  			[404, {'Content-Type' => 'text/html'}, ["Invalid action: #{action_name}"]]
	  		else
		  		response = controller_class.new(env).send(action_name)
					[200, {'Content-Type' => 'text/html'}, [response]]
				end
	  	end
  	end
  end
end
