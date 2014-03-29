class UserMailer < ActionMailer::Base
  default from: "test@from.com"

  def delivery_mail(deliveries)
    @deliveries = deliveries
    mail(:to => "test@from.com", :subject => 'delivery picking list')
  end
end