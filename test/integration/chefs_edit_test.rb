require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

	def setup
		@chef = Chef.create!(chefname: "andreas", email: "andreas@example.com",
			password: "password", password_confirmation: "password")
	end

	test "reject an invalid edit" do
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: " ", 
			email: "andreas@example.com"} }

		assert_template 'chefs/edit'
		assert_select 'div.card-header'
		assert_select 'p.card-text'
	end

	test "accept valid signup" do
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "andreas2", 
			email: "andreas2@example.com"} }

		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "andreas2", @chef.chefname
		assert_match "andreas2@example.com", @chef.email
	end

end
