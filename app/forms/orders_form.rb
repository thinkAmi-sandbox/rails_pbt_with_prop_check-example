class OrdersForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :quantity, :integer
  attribute :unit_price, :integer

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than: 0 }

  # integer型へのキャストで小数が切り捨てられるため、生入力の整数形式を検証する
  validate :integer_inputs_must_be_integer

  def total
    quantity * unit_price
  end

  private

  def integer_inputs_must_be_integer
    [:quantity, :unit_price].each do |field|
      # 変更前の値は ActiveModel::AttributeSet型の @attributes に保持される
      raw_value = @attributes.values_before_type_cast[field.to_s]
      next if raw_value.blank?
      next if integer_like_input?(raw_value)

      errors.add(field, :not_an_integer, value: raw_value)
    end
  end

  def integer_like_input?(value)
    case value
    when Integer
      true
    when String
      /\A[+-]?\d+\z/.match?(value.strip)
    when BigDecimal
      value.frac.zero?
    when Numeric
      (value % 1).zero?
    else
      false
    end
  end
end
