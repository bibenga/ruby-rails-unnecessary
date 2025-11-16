require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "the product description" do
    product = products(:one)
    assert_equal("<div><strong>Awesome</strong> product one description!</div>",
      product.description.body.to_html)
  end

  test "the product one comments" do
    product = products(:one)
    assert_equal(2, product.comments.count)
  end

  test "the product two comments" do
    product = products(:two)
    assert_equal(0, product.comments.count)
  end
end
