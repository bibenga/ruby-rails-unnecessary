require "test_helper"

class ProductsGraphQLTest < ActionDispatch::IntegrationTest
  test "should list products" do
    query = <<~GRAPHQL
      query {
        products {
          nodes {
            id
            name
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }
    assert_response :success

    data = JSON.parse(response.body)
    pp data

    assert_equal 2, data["data"]["products"]["nodes"].length
  end
end
