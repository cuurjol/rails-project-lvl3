# frozen_string_literal: true

class BulletinContact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: :correct_email?
  attribute :message, validate: true
  attribute :bulletin_id, validate: :correct_bulletin_id?
  attribute :owner_email, validate: URI::MailTo::EMAIL_REGEXP

  def headers
    {
      template_name: 'bulletin_contact',
      subject: I18n.t('mail_form.bulletin_contact.subject'),
      from: %("#{name}" <#{email}>),
      to: owner_email
    }
  end

  def bulletin
    @bulletin ||= Bulletin.find_by(id: bulletin_id)
  end

  def markdown_message
    options = %i[
      hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
      disable_indented_code_blocks strikethrough lax_spacing space_after_headers
      quote footnotes highlight underline
    ]

    Markdown.new(message, *options).to_html
  end

  private

  def correct_email?
    return if email.present? && email.match?(URI::MailTo::EMAIL_REGEXP) && email != owner_email

    errors.add(:email, email.blank? ? :blank : :invalid)
  end

  def correct_bulletin_id?
    return if bulletin.present? && bulletin.user.email == owner_email

    errors.add(:bulletin_id, :invalid)
  end
end
