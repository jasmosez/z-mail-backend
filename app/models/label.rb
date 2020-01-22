class Label < ApplicationRecord
  belongs_to :message

  @@all = []

  def initialize(attributes={})
    super(attributes)

    @@all << self
  end

  def self.all
    @@all
  end

end

