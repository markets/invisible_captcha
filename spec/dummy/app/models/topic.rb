class Topic
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :title, :body, :subtitle

  validates :title, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
