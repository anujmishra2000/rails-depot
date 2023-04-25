class UserMailer < ApplicationMailer
  default from: ADMIN_EMAIL

  def welcome(user)
    @user = user
    mail to: user.email, subject: "#{t('.welcome')} #{user.name}"
  end
end
