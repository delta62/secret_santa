# frozen_string_literal: true

require 'securerandom'
require 'time'

module SecretSanta
  class Email
    attr_reader :from, :to

    def initialize(from:, to:, subject:, text_content:, reply_to: nil)
      @headers = {}
      @from = from
      @to = to
      @text_content = text_content.strip

      set_header(key: 'From', value: from)
      set_header(key: 'To', value: to)
      set_header(key: 'Subject', value: subject)
      set_header(key: 'Reply-To', value: reply_to) if reply_to
      set_header(key: 'Date', value: generate_date)
      set_header(key: 'Message-ID', value: generate_message_id)
    end

    def to_s
      <<~EMAIL
        #{format_headers}

        #{@text_content}
      EMAIL
    end

    private

    def set_header(key:, value:)
      @headers[key] = value.to_s.strip
    end

    def format_headers
      @headers.map { |key, value| "#{key}: #{value}" }.join("\n")
    end

    def generate_message_id
      "<#{SecureRandom.uuid}@#{@from.domain}>"
    end

    def generate_date
      Time.now(in: '+00:00').rfc2822
    end
  end
end
