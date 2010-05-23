require File.dirname(__FILE__) + "/../test_helper"

context "Query" do
	test "parse input" do
    assert Query.parse("this that this:that").to_hash == {"query" => "this that", "this" => "that"}
	end

  test "parse input with order:something" do
    assert Query.parse("order:something").to_hash == {"order" => "something desc"}
  end
end
