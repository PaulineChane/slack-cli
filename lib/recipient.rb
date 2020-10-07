require 'httparty'
require_relative 'slack_api_error'

class Recipient
  attr_reader :slack_id, :name

  def initialize(slack_id: , name: )
    @slack_id = slack_id
    @name = name
  end
  # methods

  def send_message(message)
    raise NotImplementedError, "i shall be implemented soon!!!"
  end

  # we are assuming, because the CLI user won't see the code and only the program
  # itself uses it, that the url is a valid url.
  def self.get(url, params)
    response = HTTParty.get(url, query: params)
    sleep(0.5)
    raise SlackApiError if response.code != 200 || !response['ok']
    return response
  end

  # template methods
  def details
    raise NotImplementedError, "implement me in child class"
  end

  def self.list_all
    raise NotImplementedError, "implement me in child class"
  end
end