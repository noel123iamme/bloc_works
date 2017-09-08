module BlocWorks
  class Application
    def controller_and_action(env)
      _, controller, action, _ = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller = "#{controller}Controller"
      obj_controller = Object.const_get(controller)
      [obj_controller, action]
    end
  end
end


