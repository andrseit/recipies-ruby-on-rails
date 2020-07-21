module ApplicationHelper

	def avatar_image(user, options = {size: 80})
		size = options[:size]
		img_url = "https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg"
		image_tag(img_url, alt: user.chefname, class: "img-circle user-image")
	end

end
