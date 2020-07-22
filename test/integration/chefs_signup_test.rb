require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest

	test "should get signup path"  do
		get signup_path
		assert_response :success
	end

	test "reject an invalid signup" do
		get signup_path
		assert_no_difference "Chef.count" do
			post chefs_path, params: { chef: { chefname: " ", email: " ",
				password: "password", password_confirmation: " " } }
		end

		assert_template 'chefs/new'
		assert_select 'div.card-header'
		assert_select 'p.card-text'
	end

	test "accept valid signup" do
		get signup_path
		assert_difference "Chef.count", 1 do
			post chefs_path, params: { chef: { chefname: "andreas", email: "andreas@example.com",
				password: "password", password_confirmation: "password" } }
		end

		follow_redirect!
		assert_template 'chefs/show'
		assert_not flash.empty?
	end
end
