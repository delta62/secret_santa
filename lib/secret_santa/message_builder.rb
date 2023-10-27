# frozen_string_literal: true

require 'secret_santa/email'
require 'secret_santa/email_address'
require 'secret_santa/template'

module SecretSanta
  class MessageBuilder
    def initialize(subject:, body_template:, from:)
      @subject = subject
      @from = from
      @template = Template.new(template: body_template)
    end

    def build(assignment:)
      recipient = assignment.gives_to
      giver = assignment.participant
      text_content = make_text_content(recipient: recipient)
      to = EmailAddress.new(name: giver.name, email: giver.email)

      Email.new(from: @from, to: to, subject: @subject, text_content: text_content)
    end

    private

    def make_text_content(recipient:)
      @template.render(
        address1: recipient.address1,
        address2: recipient.address2,
        name: recipient.name
      )
    end
  end
end
