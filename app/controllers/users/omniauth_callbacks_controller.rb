class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.define_callback(provider)
    define_method provider do
      omniauth_signup_or_connect_or_signin(provider)
    end
  end

  User.omniauth_providers.each do |provider|
    define_callback provider
  end

  def omniauth_signup_or_connect_or_signin(provider)
    auth_hash = request.env["omniauth.auth"]

    #user = User.or([{"#{provider}_uid" => auth_hash.uid}, {email: auth_hash.info.email}]).first
    user = User.where("#{provider}_uid = ? ",auth_hash.uid).first
    if user.present?
      # user.skip_confirmation!
      user.update({
        "#{provider}_uid" => auth_hash.uid,
        "#{provider}_url" => auth_hash.info.urls[provider.to_s.capitalize],
        "#{provider}" => auth_hash.info.urls[provider.to_s.capitalize],
      })
    else
      user = User.new(
        name: auth_hash.extra.raw_info.name,
        nickname: auth_hash.info.nickname,
        email: auth_hash.info.email,
        password: Devise.friendly_token[0,20],
        picture: auth_hash.info.image,
        first_name: auth_hash.info.first_name,
        last_name: auth_hash.info.last_name,
        gender: auth_hash.extra.raw_info.gender,
        location: auth_hash.info.location,
        "#{provider}" => auth_hash.info.urls[provider.to_s.capitalize],
        "#{provider}_uid" => auth_hash.uid,
        "#{provider}_url" => auth_hash.info.urls[provider.to_s.capitalize],
      )
      # user.skip_confirmation!
      user.save!
    end

    sign_in_and_redirect user, :event => :authentication, :notice => I18n.t("devise.omniauth_callbacks.success", :kind => provider)
  end
end