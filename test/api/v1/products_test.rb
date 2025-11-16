require "test_helper"

class ProductsApiTest < ActionDispatch::IntegrationTest
  test "should list products" do
    get "/api/v1/products"
    assert_response :success
    data = JSON.parse(response.body)
    # pp data
    assert_equal 2, data["data"].length
    expected_meta = { "current_page" => 1, "per_page"=> 5, "total_pages"=> 1, "total_count"=> 2 }
    assert_equal expected_meta, data["meta"]
  end
end
