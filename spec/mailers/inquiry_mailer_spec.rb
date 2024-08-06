require 'rails_helper'

RSpec.describe InquiryMailer, type: :mailer do
  let(:inquiry) { create(:inquiry) }

  before do
    allow(ENV).to receive(:fetch).with('MAIL_ADDRESS', nil).and_return('test-email@example.com')
    allow(ENV).to receive(:fetch).with('DEFAULT_FROM_EMAIL', nil).and_return('test-from@example.com')
  end

  describe '問い合わせメール' do
    let(:mail) { described_class.with(inquiry:).contact_email }

    it '件名が正しいこと' do
      expect(mail.subject).to eq('新しい問い合わせ（Menu Maker）')
    end

    it '宛先が正しいこと' do
      expect(mail.to).to eq(['test-email@example.com'])
    end

    it '送信元が正しいこと' do
      expect(mail.from).to eq(['test-from@example.com'])
    end

    it '本文に名前が含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.name.force_encoding('UTF-8'))
    end

    it '本文にメールアドレスが含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.email.force_encoding('UTF-8'))
    end

    it '本文にメッセージが含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.message.force_encoding('UTF-8'))
    end
  end

  describe 'お問い合わせ内容確認メール' do
    let(:mail) { described_class.with(inquiry:).confirmation_email }

    it '件名が正しいこと' do
      expect(mail.subject).to eq('お問い合わせ受付完了（Menu Maker）')
    end

    it '宛先が正しいこと' do
      expect(mail.to).to eq([inquiry.email])
    end

    it '送信元が正しいこと' do
      expect(mail.from).to eq(['test-from@example.com'])
    end

    it '本文に名前が含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.name.force_encoding('UTF-8'))
    end

    it '本文にメールアドレスが含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.email.force_encoding('UTF-8'))
    end

    it '本文にメッセージが含まれること' do
      decoded_body = Base64.decode64(mail.body.encoded.split("\r\n\r\n")[1]).force_encoding('UTF-8')
      expect(decoded_body).to match(inquiry.message.force_encoding('UTF-8'))
    end
  end
end
