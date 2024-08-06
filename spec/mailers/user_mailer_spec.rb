require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'パスワードリセットメール' do
    let(:user) { create :user }
    let(:mail) { described_class.reset_password_email(user) }

    before do
      user.generate_reset_password_token!
      allow(ENV).to receive(:fetch).with('DEFAULT_FROM_EMAIL', nil).and_return('test-from@example.com')
    end

    # メールが正しく送信されるかの確認
    it 'メールが送信されること' do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    # ヘッダーのチェック
    it '件名が正しいこと' do
      expect(mail.subject).to eq('パスワードの再設定')
    end

    it '宛先が正しいこと' do
      expect(mail.to).to eq([user.email])
    end

    it '送信元が正しいこと' do
      expect(mail.from).to eq(['test-from@example.com'])
    end

    # 本文のチェック
    it 'メール本文にパスワードリセットのURLが含まれていること' do
      expect(mail.body.encoded.split("\r\n").map { |i| Base64.decode64(i) }.join).to match(edit_password_reset_url(user.reset_password_token))
    end
  end
end
