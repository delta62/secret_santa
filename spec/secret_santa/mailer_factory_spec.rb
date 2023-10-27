# frozen_string_literal: true

require 'secret_santa/mailer_factory'

module SecretSanta
  RSpec.describe MailerFactory do
    context 'dry run mode' do
      it 'creates a stub mailer for dry runs' do
        factory = make_factory(dry_run: true)
        expect(factory.build).to be_an_instance_of(StubMailer)
      end
    end

    context 'real mode' do
      let(:mailer) { class_double('SecretSanta::Mailer').as_stubbed_const }

      it 'creates a real mailer' do
        factory = make_factory(dry_run: false)
        expect(factory.build).to be_an_instance_of(Mailer)
      end

      it 'provides the given smtp username to the mailer' do
        expect(mailer).to receive(:new).with(hash_including(smtp_username: 'user1'))
        make_factory(dry_run: false, smtp_username: 'user1').build
      end

      it 'provides the given smtp password to the mailer' do
        expect(mailer).to receive(:new).with(hash_including(smtp_password: 'pass1'))
        make_factory(dry_run: false, smtp_password: 'pass1').build
      end

      it 'provides the given smtp host to the mailer' do
        expect(mailer).to receive(:new).with(hash_including(smtp_host: 'smtp.example.com'))
        make_factory(dry_run: false, smtp_host: 'smtp.example.com').build
      end

      it 'provides the given smtp port to the mailer' do
        expect(mailer).to receive(:new).with(hash_including(smtp_port: '25'))
        make_factory(dry_run: false, smtp_port: '25').build
      end

      it 'provides the given smtp authtype to the mailer' do
        expect(mailer).to receive(:new).with(hash_including(authtype: :plain))
        make_factory(dry_run: false, authtype: :plain).build
      end
    end

    def make_factory(dry_run:, smtp_username: 'user', smtp_password: 'pass', smtp_port: 25,
                     smtp_host: 'smtp.example.com', authtype: :cram_md5)
      MailerFactory.new(
        dry_run: dry_run,
        smtp_host: smtp_host,
        smtp_port: smtp_port,
        smtp_username: smtp_username,
        smtp_password: smtp_password,
        authtype: authtype
      )
    end
  end
end
