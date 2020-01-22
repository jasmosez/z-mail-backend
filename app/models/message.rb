class Message
  #  < ApplicationRecord
  # belongs_to :token
  # has_many :labels

  attr_reader :google_id, :date, :subject, :from, :snippet, :labels

  @@all = []

  def initialize(attributes={})
    # super(attributes)
    # byebug
    @google_id = attributes[:google_id]
    @date = attributes[:date]
    @subject = attributes[:subject]
    @from = attributes[:from]
    @snippet = attributes[:snippet]
    @labels = self.label_names

    @@all << self
  end

  def self.all
    @@all
  end

  def labels
    Label.all.select do |label|
      label.google_id == self.google_id
    end
  end

  def label_names
    self.labels.map do |label|
      label.name
    end
  end

end
