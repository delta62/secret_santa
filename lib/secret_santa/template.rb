# frozen_string_literal: true

module SecretSanta
  class Template
    def initialize(template:)
      @template = template
    end

    def self.from_file(path:)
      template = File.read(path)
      new(template: template)
    end

    def render(args = {})
      @template.gsub(/{{(\w+)}}/) do |match|
        key = match[2..-3].to_sym
        args[key]
      end
    end
  end
end
