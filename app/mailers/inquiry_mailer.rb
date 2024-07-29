class InquiryMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def contact_email
    @inquiry = params[:inquiry]
    mail(
      to: 'your-email@example.com',
      subject: t('.inquiry')
    )
  end

  def confirmation_email
    @inquiry = params[:inquiry]
    mail(
      to: @inquiry.email,
      subject: t('.confirmation_email')
    )
  end
end
