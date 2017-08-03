require "bloc_works/version"

module BlocWorks
  class Application
  	def call(env)
  		# env.each { |k, v| puts "key: #{k} value: #{v}\n" }
  		[200, {'Content-Type' => 'text/html'}, ["Hello Blocheads!"]]
  	end
  end
end
