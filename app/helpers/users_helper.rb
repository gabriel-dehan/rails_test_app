module UsersHelper
  def gravatar_for user
    gravatar = "https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email.downcase)}"
    image_tag gravatar, alt: user.name, class: 'gravatar'
  end
end
