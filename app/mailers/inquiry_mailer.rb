class InquiryMailer < ApplicationMailer
  def contact_email
    @inquiry = params[:inquiry]
    mail(
      to: ENV.fetch('MAIL_ADDRESS', nil),
      from: ENV.fetch('DEFAULT_FROM_EMAIL', nil),
      subject: t('.inquiry')
    )
  end

  def confirmation_email
    @inquiry = params[:inquiry]
    mail(
      to: @inquiry.email,
      from: ENV.fetch('DEFAULT_FROM_EMAIL', nil),
      subject: t('.confirmation_email')
    )
  end
end
