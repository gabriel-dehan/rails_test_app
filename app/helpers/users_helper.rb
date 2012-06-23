module UsersHelper
  def gravatar_for user, options = { size: 50 }
    gravatar = "https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}"
    image_tag gravatar, alt: user.name, class: 'gravatar', width: options[:size], height: options[:size]
  end
end
