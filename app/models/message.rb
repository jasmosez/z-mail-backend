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
    @to = attributes[:to]
    @message_id = attributes[:message_id]
    @snippet = attributes[:snippet]
    @labels = self.label_names.uniq

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

  def self.make_message_hash(message, user)
    message_hash = {}

    # date
    message_hash[:date] = Time.at(message.internal_date/1000)
    
    # id
    message_hash[:google_id] = message.id
    
    # subject
    subject_header = message.payload.headers.find do |header|
      header.name.downcase == "subject"
    end
    subject_header ? message_hash[:subject] = subject_header.value : message_hash[:subject] = ""
    
    # from
    from_header = message.payload.headers.find do |header|    
      header.name.downcase == "from"
    end
    from_header ? message_hash[:from] = from_header.value : message_hash[:from] = ""

    # to
    to_header = message.payload.headers.find do |header|    
      header.name.downcase == "to"
    end
    to_header ? message_hash[:to] = to_header.value : message_hash[:to] = ""

    # message_id
    message_id_header = message.payload.headers.find do |header|    
      header.name.downcase == "message-id"
    end
    message_id_header ? message_hash[:message_id] = message_id_header.value : message_hash[:message_id] = ""

    # description
    message_hash[:snippet] = message.snippet
    
    # labels
    # in/out. Out is determined by having "SENT" within label_ids. In is everything that is not out.
    # inbox? determined by having "INBOX" within label_ids
    message.label_ids.each do |label_id|
      Label.new(google_id: message.id, name: label_id)
      # message_hash[:label_ids]
    end

    # need to include a Token identifier of some sort. Could be the db ID. Could be somethign else?
    message_hash[:token_id] = user.id

    return message_hash
    # byebug
  end



end
