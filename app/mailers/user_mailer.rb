class UserMailer < ActionMailer::Base
  default from: "deliveries@certusdelivery.com"

  def delivery_mail(deliveries)
    @deliveries = deliveries
    mail(:to => "deliveries@certusdelivery.com", :subject => 'Delivery Picking List')
  end

  def customer_notification(delivery)
    @delivery = delivery
    mail(:to => delivery.customer_email, :subject => 'CertusDelivery Notification') if delivery.customer_email.present?
  end
end