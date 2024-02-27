require "test_helper"

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get stock" do
    get topics_stock_url
    assert_response :success
  end
end
