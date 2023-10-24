# frozen_string_literal: true

require 'secret_santa/csv_parser'

module SecretSanta
  RSpec.describe CsvParser do
    context 'initialize' do
      it "raises when the given path can't be read" do
        expect { make_parser(csv_name: 'not_a_file') }.to raise_error(SystemCallError)
      end

      it 'does not raise an error when the file exists' do
        make_parser(csv_name: 'one_row')
      end
    end

    context 'parse' do
      it 'parses names from the first column' do
        participants = make_parser(csv_name: 'one_row').parse
        expect(participants.first.name).to eq('bob')
      end

      it 'parses emails from the second column' do
        participants = make_parser(csv_name: 'one_row').parse
        expect(participants.first.email).to eq('bob@example.com')
      end

      it 'parses address1 from the third column' do
        participants = make_parser(csv_name: 'one_row').parse
        expect(participants.first.address1).to eq('123 fake st')
      end

      it 'parses address2 from the fourth column' do
        participants = make_parser(csv_name: 'one_row').parse
        expect(participants.first.address2).to eq('Burns, WY  82053')
      end

      it 'parses groups from the fifth column' do
        participants = make_parser(csv_name: 'one_row').parse
        expect(participants.first.group).to be(:bob_group)
      end

      it 'sets sets group to nil when no group is provided' do
        participants = make_parser(csv_name: 'one_row_no_group').parse
        expect(participants.first.group).to be_nil
      end

      it 'parses 0 rows successfully' do
        participants = make_parser(csv_name: 'empty').parse
        expect(participants).to be_empty
      end

      it 'parses multiple rows successfully' do
        participants = make_parser(csv_name: 'three_rows').parse
        expect(participants.length).to be(3)
      end
    end

    def make_parser(csv_name:)
      csv_path = "spec/inputs/#{csv_name}.csv"
      CsvParser.new(csv_path: csv_path)
    end
  end
end
