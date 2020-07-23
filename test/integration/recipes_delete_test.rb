require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
	def setup
		@user = Chef.create!(chefname: "andreas", email: "andreas@example.com",
			password: "password", password_confirmation: "password")
		@recipe = Recipe.create!(name: "vegetables saute",
			description: "great vegetable saute, add vegetables and oil", chef: @user)
	end

	test "successfully delete a recipe" do
		sign_in_as(@user, "password")
		get recipe_path(@recipe)
		assert_template 'recipes/show'
		assert_select 'a[href=?]', recipe_path(@recipe), text: "Delete"
		assert_difference 'Recipe.count', -1 do
			delete recipe_path(@recipe)
		end
		assert_redirected_to recipes_path
		assert_not flash.empty?
	end
end
