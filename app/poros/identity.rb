class Identity
  attr_reader :id,
              :label

  def initialize(attributes)
    @id = attributes[:id]
    @label = attributes[:attributes][:identity_label]
  end
end