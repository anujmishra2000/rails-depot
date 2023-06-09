class UserMailer < ApplicationMailer
  default from: ::ADMIN_EMAIL

  def welcome(user)
    @user = user
    mail to: @user.email, subject: t('.subject', name: @user.name)
  end
end
