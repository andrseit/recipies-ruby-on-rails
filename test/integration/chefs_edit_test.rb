require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

	def setup
		@chef = Chef.create!(chefname: "andreas", email: "andreas@example.com",
			password: "password", password_confirmation: "password")
		@chef2 = Chef.create!(chefname: "john", email: "john@example.com",
			password: "password", password_confirmation: "password")
		@admin = Chef.create!(chefname: "andreas1", email: "andreas1@example.com",
			password: "password", password_confirmation: "password", admin: true)
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

	test "accept valid edit" do
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

	test "accept edit by admin user" do
		sign_in_as(@admin, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "andreas3", 
			email: "andreas3@example.com"} }

		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "andreas3", @chef.chefname
		assert_match "andreas3@example.com", @chef.email		
	end

	test "redirect edit attempt by another non-admin user" do
		sign_in_as(@chef2, "password")
		updated_name = "joe"
		update_email = "joe@example.com"
		patch chef_path(@chef), params: { chef: { chefname: updated_name, 
			email: update_email} }

		assert_redirected_to chefs_path
		assert_not flash.empty?
		@chef.reload
		assert_match "andreas", @chef.chefname
		assert_match "andreas@example.com", @chef.email		
	end

end
