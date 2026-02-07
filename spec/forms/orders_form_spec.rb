require 'rails_helper'

RSpec.describe OrdersForm do
  describe 'バリデーション' do
    subject(:form) { described_class.new(quantity: quantity, unit_price: unit_price) }

    context 'いずれも正の整数化できる文字列の場合' do
      let(:quantity) { '2' }
      let(:unit_price) { '300' }

      it 'validになり、エラーメッセージも含まれていないこと' do
        expect(form).to be_valid
        expect(form.errors.full_messages).to be_empty
      end
    end

    context 'quantityがnilの場合' do
      let(:quantity) { nil }
      let(:unit_price) { '300' }

      it 'quantityが数値ではないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Quantity is not a number')
      end
    end

    context 'quantityが0の場合' do
      let(:quantity) { '0' }
      let(:unit_price) { '300' }

      it 'quantityが0より大きくなければならないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Quantity must be greater than 0')
      end
    end

    context 'quantityが負数の場合' do
      let(:quantity) { '-1' }
      let(:unit_price) { '300' }

      it 'quantityが0より大きくなければならないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Quantity must be greater than 0')
      end
    end

    context 'quantityが小数の文字列の場合' do
      let(:quantity) { '2.9' }
      let(:unit_price) { '300' }

      it 'quantityが整数ではないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Quantity must be an integer')
      end
    end

    context 'quantityが数値でない文字列の場合' do
      let(:quantity) { 'a' }
      let(:unit_price) { '300' }

      it 'quantityに関するエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Quantity must be greater than 0')
        expect(form.errors.full_messages).to include('Quantity must be an integer')
      end
    end

    context 'unit_priceがnilの場合' do
      let(:quantity) { '2' }
      let(:unit_price) { nil }

      it 'unit_priceが数値ではないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Unit price is not a number')
      end
    end

    context 'unit_priceが0の場合' do
      let(:quantity) { '2' }
      let(:unit_price) { '0' }

      it 'unit_priceが0より大きくなければならないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Unit price must be greater than 0')
      end
    end

    context 'unit_priceが負数の場合' do
      let(:quantity) { '2' }
      let(:unit_price) { '-1' }

      it 'unit_priceが0より大きくなければならないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Unit price must be greater than 0')
      end
    end

    context 'unit_priceが小数の場合' do
      let(:quantity) { '2' }
      let(:unit_price) { '99.99' }

      it 'unit_priceが整数ではないというエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Unit price must be an integer')
      end
    end

    context 'unit_priceが数値でない文字列の場合' do
      let(:quantity) { '2' }
      let(:unit_price) { 'a' }

      it 'unit_priceに関するエラーになること' do
        expect(form).to be_invalid
        expect(form.errors.full_messages).to include('Unit price must be greater than 0')
        expect(form.errors.full_messages).to include('Unit price must be an integer')
      end
    end
  end

  describe 'rspec-parameterizedを使ったバリデーション' do
    subject(:form) { described_class.new(quantity: quantity, unit_price: unit_price) }

    where do
      {
        'いずれも正の整数化できる文字列の場合' => {
          quantity: '2',
          unit_price: '300',
          expected_valid: true,
          expected_messages: []
        },
        'quantityがnilの場合' => {
          quantity: nil,
          unit_price: '300',
          expected_valid: false,
          expected_messages: ['Quantity is not a number']
        },
        'quantityが0の場合' => {
          quantity: '0',
          unit_price: '300',
          expected_valid: false,
          expected_messages: ['Quantity must be greater than 0']
        },
        'quantityが負数の場合' => {
          quantity: '-1',
          unit_price: '300',
          expected_valid: false,
          expected_messages: ['Quantity must be greater than 0']
        },
        'quantityが小数の文字列の場合' => {
          quantity: '2.9',
          unit_price: '300',
          expected_valid: false,
          expected_messages: ['Quantity must be an integer']
        },
        'quantityが数値でない文字列の場合' => {
          quantity: 'a',
          unit_price: '300',
          expected_valid: false,
          expected_messages: ['Quantity must be greater than 0', 'Quantity must be an integer']
        },
        'unit_priceがnilの場合' => {
          quantity: '2',
          unit_price: nil,
          expected_valid: false,
          expected_messages: ['Unit price is not a number']
        },
        'unit_priceが0の場合' => {
          quantity: '2',
          unit_price: '0',
          expected_valid: false,
          expected_messages: ['Unit price must be greater than 0']
        },
        'unit_priceが負数の場合' => {
          quantity: '2',
          unit_price: '-1',
          expected_valid: false,
          expected_messages: ['Unit price must be greater than 0']
        },
        'unit_priceが小数の場合' => {
          quantity: '2',
          unit_price: '99.99',
          expected_valid: false,
          expected_messages: ['Unit price must be an integer']
        },
        'unit_priceが数値でない文字列の場合' => {
          quantity: '2',
          unit_price: 'a',
          expected_valid: false,
          expected_messages: ['Unit price must be greater than 0', 'Unit price must be an integer']
        }
      }
    end

    with_them do
      it '期待どおりの妥当性とエラーメッセージになること' do
        expect(form.valid?).to eq(expected_valid)
        expect(form.errors.full_messages).to contain_exactly(*expected_messages)
      end
    end
  end

  describe '#total' do
    subject(:total) { form.total }

    let(:form) { described_class.new(quantity: '2', unit_price: '300') }

    it 'quantityとunit_priceの積を返すこと' do
      expect(total).to eq(600)
    end
  end
end
