require 'httparty'
require_relative 'slack_api_error'


class Recipient
  attr_reader :slack_id, :name
  # SLACK_TOKEN = ENV['SLACK_TOKEN']
  def initialize(slack_id:, name:)
    @slack_id = slack_id
    @name = name
  end
  # methods

  def send_message(message, emoji: "", send_as: "")
    # as recommended by Slack API for slack apps
    if message.length > 4000 # message too long
      # we don't want to break the program unless the API can't connect
      # so we do a puts
      raise SlackApiError, "Message too long. Try again."
      return false
    end
    url = 'https://slack.com/api/chat.postMessage'
    query = { token: Recipient.token,
              text: message,
              channel: @slack_id,
              emoji: emoji,
              send_as: send_as} # to post to both users and channel
    sleep(1)
    response = HTTParty.post(url, query: query)

    # check for successful post
    unless response.parsed_response['ok'] && response.code == 200
      # we don't want to break the program here because the reason
      # could be anything
      raise SlackApiError, "Error: #{response.parsed_response['error']}. Please try again"
      return false
    end

    return response.parsed_response
  end

  def self.token
    return ENV['SLACK_TOKEN']
  end
  # we are assuming, because the CLI user won't see the code and only the program
  # itself uses it, that the url is a valid url.
  def self.get(url, params)
    response = HTTParty.get(url, query: params)
    sleep(0.5)
    if response.code != 200 || !response.parsed_response['ok']
      raise SlackApiError, "Error: #{response.parsed_response['error']}. Please try again"
    end
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
