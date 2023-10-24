# frozen_string_literal: true

require 'secret_santa/template'

module SecretSanta
  RSpec.describe Template do
    context 'from_file' do
      it 'raises an error when the given file path does not exist' do
        expect { Template.from_file(path: 'not_a_file') }.to raise_error(SystemCallError)
      end

      it 'loads content from the given file' do
        tpl = Template.from_file(path: 'spec/inputs/one_var.tpl')
        result = tpl.render(var: 'value')
        expect(result).to eq("this template is of great value!\n")
      end
    end

    context 'render' do
      it 'renders a template with no variables' do
        tpl = Template.new(template: 'hello world')
        expect(tpl.render).to eq('hello world')
      end

      it 'renders a template with a single variable' do
        tpl = Template.new(template: 'hello {{user}}')
        result = tpl.render(user: 'bob')
        expect(result).to eq('hello bob')
      end

      it 'renders a template with the same variable multiple times' do
        tpl = Template.new(template: 'the {{user}} is {{user}}')
        result = tpl.render(user: 'bob')
        expect(result).to eq('the bob is bob')
      end

      it 'renders a template with multiple different variables' do
        tpl = Template.new(template: 'the {{user}} is {{status}}')
        result = tpl.render(user: 'bob', status: 'good')
        expect(result).to eq('the bob is good')
      end

      it 'ignores unused variables' do
        tpl = Template.new(template: 'cool beans')
        result = tpl.render(user: 'bob')
        expect(result).to eq('cool beans')
      end
    end
  end
end
