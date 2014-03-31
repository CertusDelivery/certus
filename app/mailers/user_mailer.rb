class UserMailer < ActionMailer::Base
  default from: "deliveries@certusdelivery.com"

  def delivery_mail(deliveries)
    @deliveries = deliveries
    mail(:to => "deliveries@certusdelivery.com", :subject => 'delivery picking list')
  end
end