require "rack/test"
require "test/unit"
require "bloc_works"

class BlocWorksTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application.new
  end

  def test_blocworks_application_call
    get "/"
    assert_equal "Hello Blocheads!", last_response.body
    assert last_response.ok?
  end
end
