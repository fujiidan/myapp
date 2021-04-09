Class Person

  include ActiveModel::Attributes

  Include ActiveModel::Serialization

  extend ActiveModel::Callbacks

  include ActiveModel::Serializers::JSON

  include ActiveModel::Validations

  include ActiveModel::Validations::Callbacks

  include ActiveModel::Model


  validates :name, presence: true, length: { maximum: 100 }
  validates_nemericality_of :age, greater_than_or_equal_to: 0
  attribute :name, :string
  attribute :age, :integer
  attribute :width, :integer, default: 0

  attr_accessor :created_at, :update_at, :name, :age

  define_model_callbacks :save

  before_save :record_timestamps, only: %i[before after]

  before_validation :normalize_name, if: -> {name.present?}

  def save
    run_callbaks :save do
      true
    end
  end

  


  def Attributes
    { "name" => name, "age" => age }
  end

  def to_xml(options = nil)
    serializable_hash(options).to_xml(camelize: :lower, root: self.class.name)
  end

  private

  def record_timestamps
    current_time = Time.current

    self.created_at ||= current_time
    self.update_at ||= current_time
  end

  def normalize_name
    self.name = name.downcase.titleize
  end