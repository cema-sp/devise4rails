class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def github
		# raise request.env["omniauth.auth"].to_hash.slice("provider","uid").to_yaml
		user = User.process_omniauth(request.env["omniauth.auth"])
		if user.persisted?
			flash.notice = "Signed in with GitHub!"
			sign_in_and_redirect user
		else
			session["devise.user_attributes"] = user.attributes
			redirect_to new_user_registration_url
		end
	end
end
