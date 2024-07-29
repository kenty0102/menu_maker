class InquiriesController < ApplicationController
  skip_before_action :require_login

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)

    if @inquiry.save
      # 管理者への問い合わせメール送信
      InquiryMailer.with(inquiry: @inquiry).contact_email.deliver_now
      # ユーザーへの確認メール送信
      InquiryMailer.with(inquiry: @inquiry).confirmation_email.deliver_now

      # 完了画面にリダイレクト
      redirect_to complete_inquiries_path, success: t('.success')
    else
      # 入力ページに戻る
      render :new, status: :unprocessable_entity
    end
  end

  def complete; end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message)
  end
end
