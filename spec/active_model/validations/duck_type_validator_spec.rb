# frozen_string_literal: true

RSpec.describe ActiveModel::Validations::DuckTypeValidator do
  let(:validator) { described_class.new(options) }
  let(:options) do
    { attributes: attribute }.merge([[operator, methods]].to_h).merge(option)
  end
  let(:attribute) { :pet }
  let(:operator) { :all }
  let(:methods) { :drink }
  let(:option) { { allow_nil: false } }

  let(:record) do
    instance_double('Person', pet: value).tap do |instance|
      instance.class.class_eval do
        include ActiveModel::Validations
      end
    end
  end

  describe '.new' do
    context 'without any operator' do
      let(:options) { { attributes: attribute } }

      it { expect { validator }.to raise_error ArgumentError }
    end

    context 'with some operators' do
      let(:options) do
        { attributes: attribute, all: %i[house food], any: %i[house drink] }
      end

      it { expect { validator }.to raise_error ArgumentError }
    end
  end

  describe '#validate_each' do
    before { validator.validate_each(record, attribute, value) }

    context 'with all operator' do
      let(:operator) { :all }
      let(:methods) { %i[drink house] }

      context 'when value responds to all methods' do
        let(:value) { instance_double('Parrot', drink: 'water', house: 'nest') }

        it 'does not set errors' do
          expect(record.errors).to be_empty
        end
      end

      context 'when value does not respond to methods' do
        let(:value) { 'parrot' }

        it 'sets errors' do
          expect(record.errors).not_to be_empty
        end
      end
    end

    context 'with any operator' do
      let(:operator) { :any }
      let(:methods) { %i[drink house] }

      context 'when value responds to at least one method' do
        let(:value) { instance_double('Parrot', drink: 'water') }

        it 'does not set errors' do
          expect(record.errors).to be_empty
        end
      end

      context 'when value does not respond to methods' do
        let(:value) { 'parrot' }

        it 'sets errors' do
          expect(record.errors).not_to be_empty
        end
      end
    end

    context 'with one operator' do
      let(:operator) { :one }
      let(:methods) { %i[drink house] }

      context 'when value responds to only one method' do
        let(:value) { instance_double('Parrot', drink: 'water') }

        it 'does not set errors' do
          expect(record.errors).to be_empty
        end
      end

      context 'when value does not respond to methods' do
        let(:value) { 'parrot' }

        it 'sets errors' do
          expect(record.errors).not_to be_empty
        end
      end

      context 'when value responds to more than one method' do
        let(:value) { instance_double('Parrot', drink: 'water', house: 'nest') }

        it 'sets errors' do
          expect(record.errors).not_to be_empty
        end
      end
    end

    context 'with none operator' do
      let(:operator) { :none }
      let(:methods) { %i[drink house] }

      context 'when value responds to methods' do
        let(:value) { instance_double('Parrot', drink: 'water') }

        it 'sets errors' do
          expect(record.errors).not_to be_empty
        end
      end

      context 'when value does not respond to methods' do
        let(:value) { 'parrot' }

        it 'does not set errors' do
          expect(record.errors).to be_empty
        end
      end
    end
  end
end
