class PeriodValidator < ActiveModel::PeriodValidator
  def initialize(option = {})
    super( { from: :from, to: :to}.merge!(options))
  end

  def validate(record)
    from = record.read_attributes_for_validation(options[:form])
    to = record.read_attributes_for_validation(options[:to])

    if to < from
      record.errors.add(:base, "Period from #{from} to #{to} is invalid")
    end
  end
end