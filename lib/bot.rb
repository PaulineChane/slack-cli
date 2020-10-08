require_relative 'user'
# an excessive but object oriented solution
class Bot < User
  attr_reader :slack_id, :name, :real_name, :time_zone, :is_bot, :send_as, :emoji
  def initialize(slack_id: , name:, real_name:, time_zone: ,is_bot: , send_as: '', emoji: '')
    super(slack_id: slack_id,
          name: name,
          real_name: real_name,
          time_zone: time_zone,
          is_bot: is_bot)
    @send_as = send_as
    @emoji = emoji
  end

  def self.current_bot
    users = User.list_all
    url = 'https://slack.com/api/auth.test'
    query = {token: Bot.token}
    sleep(0.5)
    response = HTTParty.get(url, query: query)['user_id']
    user = users.find{ |user| user.slack_id == response}
    return Bot.new(slack_id: user.slack_id,
                   name: user.name,
                   real_name: user.real_name,
                   time_zone: user.time_zone,
                   is_bot: user.is_bot)
  end

  def set_emoji(emoji)
    # regex checks for correct emoji format:
    # (:EMOJI:, EMOJI, alphanumeric and dashes only (can also have exactly TWO colons on either side))
    unless  /^(:[a-zA-Z0-9-]+:)/ =~ emoji || /^([a-zA-Z0-9-]+)/
     raise ArgumentError, "invalid emoji"
    end
    @emoji = emoji
    return emoji
  end

  def set_send_as (username)
    @send_as = username
    return username
  end

  def self.list_all
    response = super.list_all
    return response.filter{ |user| user.is_bot || user.slack_id == "USLACKBOT"}
  end

  def send_message(message)
    # as recommended by Slack API for slack apps
    if message.length > 4000 # message too long
      # we don't want to break the program unless the API can't connect
      # so we do a puts
      raise SlackApiError, "Message too long. Try again."
      return false
    end
    url = 'https://slack.com/api/chat.postMessage'
    query = { token: Bot.token,
              text: message,
              channel: @slack_id,
              username: @send_as,
              icon_emoji: @emoji} # to post to both users and channel
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
end