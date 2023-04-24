class UserMailer < ApplicationMailer
  default from: ADMIN_EMAIL

  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome #{user.name}"
  end
end
