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
    # as recommended by Slack API for slack apps
    if message.length > 4000 # message too long
      # we don't want to break the program unless the API can't connect
      # so we do a puts
      puts "Message too long. Try again."
      return false
    end
    url = '	https://slack.com/api/chat.postMessage'
    query = {token: ENV['SLACK_TOKEN'],
             text: message,
             channel: @slack_id # to post to both users and channel
            }
    sleep(1)
    response = HTTParty.post(url, query: query)

    # check for successful post
    raise SlackApiError, "Failed request" if response.code != 200

    unless response['ok']
      # we don't want to break the program unless the API can't connect
      # so we do a puts
      puts "Error: #{response['error']}. Please try again"
      return false
    end

    return true
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