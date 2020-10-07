require_relative 'recipient'
require 'table_print'
require 'dotenv'

Dotenv.load


class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(slack_id:, name:, topic:, member_count:)
    super(slack_id, name)
    @topic = topic
    @member_count = member_count
  end

  def details
    return tp self, :slack_id, :name, :topic, :member_count
  end

  def self.list_all
    url = "https://slack.com/api/conversations.list"
    param = {token: ENV["SLACK_TOKEN"]}
    raw_channels = Channel.get(url, param)['channels']
    all_channels = raw_channels.map do |channel|
      Channel.new(slack_id: channel["id"],
                  name: channel["name"],
                  topic: channel["topic"]["value"],
                  member_count: channel["num_members"])
    end
    return all_channels
  end
end