require "erubis"
require 'pry'
 
module BlocWorks
  class Controller
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send(action)
      if has_response?
        rack_response = get_response
        [rack_response.status, rack_response.header, [rack_response.body].flatten]
      else
        [200, {'Content-Type' => 'text/html'}, [text].flatten]
      end
    end

    def self.action(action, response = {})
      proc { |env| self.new(env).dispatch(action, response) }
    end 

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge(@routing_params)
    end 

    def response(text, status = 200, headers = {})
      raise "Cannot respond multiple times" unless @response.nil?
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def render(*args)
      view = @routing_params["action"] || "welcome"
      locals = {}
      if !args.empty?
        if args[0].is_a? Hash
          locals = args[0]
        else
          view = args[0].to_s
          locals = args[1] unless nil?
        end
      end
      response(create_response_array(view, locals))
    end

    def get_response
      @response
    end

    def has_response?
      !@response.nil? 
    end 

    def create_response_array(view, locals = {})
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      if File.file? filename then
        template = File.read(filename)
      else
        template = "view not found: #{view}"
      end
      # binding.pry 
      self.instance_variables.each do |var|
        locals[var] = self.instance_variable_get(var)
      end

      eruby = Erubis::Eruby.new(template)
      # binding.pry 
      eruby.result(locals)
    end

    def redirect_to(url)
      @response = Rack::Response.new
      @response.redirect(url)
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      BlocWorks.snake_case(klass)
    end
  end
end
