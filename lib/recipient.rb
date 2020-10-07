require 'httparty'

class Recipient

  def initialize(slack_id, name)
    @slack_id = slack_id
    @name = name
  end
  # methods

  def send_message(message)
    raise NotImplementedError, "implement me in child class"
  end

  def self.get(url, params)
    response = HTTParty.get(url, query: params)
  end

  # template methods
  def details
    raise NotImplementedError, "implement me in child class"
  end

  def self.list_all
    raise NotImplementedError, "implement me in child class"
  end
end