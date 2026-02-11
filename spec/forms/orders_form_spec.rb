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

  context '#total' do
    subject(:total) { form.total }

    let(:form) { described_class.new(quantity: '2', unit_price: '300') }

    it 'quantityとunit_priceの積を返すこと' do
      expect(total).to eq(600)
    end
  end

  describe 'prop_checkを使ったプロパティベーステスト' do
    G = PropCheck::Generators

    context 'バリデーション' do
      context '例示ベースと1:1で対応する書き方' do
        let(:positive_integer_string) { G.positive_integer.map(&:to_s) }
        let(:negative_integer_string) { G.negative_integer.map(&:to_s) }
        let(:positive_decimal_string) { G.tuple(G.positive_integer, G.positive_integer).map { |i, f| "#{i}.#{f}" } }
        let(:non_numeric_string) { G.printable_string.where { |s| s !~ /\A[+-]?\d+(\.\d+)?\z/ } }
        let(:non_numeric_string_without_empty_string) { G.printable_string(empty: false).where { |s| s !~ /\A[+-]?\d+(\.\d+)?\z/ } }

        context 'いずれも正の整数化できる文字列の場合' do
          it 'validになり、エラーメッセージも含まれていないこと' do
            PropCheck.forall(quantity: positive_integer_string, unit_price: positive_integer_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_valid
              expect(form.errors.full_messages).to be_empty
            end
          end
        end

        context 'quantityがnilの場合' do
          it 'quantityが数値ではないというエラーになること' do
            PropCheck.forall(unit_price: positive_integer_string) do |unit_price:|
              form = described_class.new(quantity: nil, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Quantity is not a number')
            end
          end
        end

        context 'quantityが0の場合' do
          it 'quantityが0より大きくなければならないというエラーになること' do
            PropCheck.forall(unit_price: positive_integer_string) do |unit_price:|
              form = described_class.new(quantity: '0', unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Quantity must be greater than 0')
            end
          end
        end

        context 'quantityが負数の場合' do
          it 'quantityが0より大きくなければならないというエラーになること' do
            PropCheck.forall(quantity: negative_integer_string, unit_price: positive_integer_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Quantity must be greater than 0')
            end
          end
        end

        context 'quantityが小数の文字列の場合' do
          it 'quantityが整数ではないというエラーになること' do
            PropCheck.forall(quantity: positive_decimal_string, unit_price: positive_integer_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Quantity must be an integer')
            end
          end
        end

        context 'quantityが数値でない文字列の場合' do
          it 'quantityに関するエラーになること' do
            pending('空文字を考慮できていないテストケース')
            PropCheck.forall(quantity: non_numeric_string, unit_price: positive_integer_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Quantity must be greater than 0')
              expect(form.errors.full_messages).to include('Quantity must be an integer')
            end
          end

          context 'quantityが空文字の場合' do
            it 'quantityが空文字からnilへ変換され、エラーとなること' do
              PropCheck.forall(unit_price: positive_integer_string) do |unit_price:|
                form = described_class.new(quantity: '', unit_price:)

                expect(form).to be_invalid
                expect(form.errors.full_messages).to include('Quantity is not a number')
              end
            end
          end

          context 'quantityが数値・空文字以外の文字列の場合' do
            it 'quantityに関するエラーになること' do
              PropCheck.forall(quantity: non_numeric_string_without_empty_string, unit_price: positive_integer_string) do |quantity:, unit_price:|
                form = described_class.new(quantity:, unit_price:)

                expect(form).to be_invalid
                expect(form.errors.full_messages).to include('Quantity must be greater than 0')
                expect(form.errors.full_messages).to include('Quantity must be an integer')
              end
            end
          end
        end

        context 'unit_priceがnilの場合' do
          it 'unit_priceが数値ではないというエラーになること' do
            PropCheck.forall(quantity: positive_integer_string) do |quantity:|
              form = described_class.new(quantity:, unit_price: nil)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Unit price is not a number')
            end
          end
        end

        context 'unit_priceが0の場合' do
          it 'unit_priceが0より大きくなければならないというエラーになること' do
            PropCheck.forall(quantity: positive_integer_string) do |quantity:|
              form = described_class.new(quantity:, unit_price: '0')

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Unit price must be greater than 0')
            end
          end
        end

        context 'unit_priceが負数の場合' do
          it 'unit_priceが0より大きくなければならないというエラーになること' do
            PropCheck.forall(quantity: positive_integer_string, unit_price: negative_integer_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Unit price must be greater than 0')
            end
          end
        end

        context 'unit_priceが小数の場合' do
          it 'unit_priceが整数ではないというエラーになること' do
            PropCheck.forall(quantity: positive_integer_string, unit_price: positive_decimal_string) do |quantity:, unit_price:|
              form = described_class.new(quantity:, unit_price:)

              expect(form).to be_invalid
              expect(form.errors.full_messages).to include('Unit price must be an integer')
            end
          end
        end

        context 'unit_priceが数値でない文字列の場合' do
          context 'unit_priceが空文字の場合' do
            it 'unit_priceが空文字からnilへ変換され、エラーとなること' do
              PropCheck.forall(quantity: positive_integer_string) do |quantity:|
                form = described_class.new(quantity: , unit_price: '')

                expect(form).to be_invalid
                expect(form.errors.full_messages).to include('Unit price is not a number')
              end
            end
          end

          context 'unit_priceが数値・空文字以外の文字列の場合' do
            it 'unit_priceに関するエラーになること' do
              PropCheck.forall(quantity: positive_integer_string, unit_price: non_numeric_string_without_empty_string) do |quantity:, unit_price:|
                form = described_class.new(quantity:, unit_price:)

                expect(form).to be_invalid
                expect(form.errors.full_messages).to include('Unit price must be greater than 0')
                expect(form.errors.full_messages).to include('Unit price must be an integer')
              end
            end
          end
        end
      end
    end
  end
end
