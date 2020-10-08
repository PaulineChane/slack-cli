require_relative 'recipient'
require 'table_print'

class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(slack_id:, name:, topic:, member_count:)
    super(slack_id: slack_id, name: name)
    @topic = topic
    @member_count = member_count
  end

  def details
    tp self, :slack_id, :name, :topic, :member_count
    return {"SLACK_ID": @slack_id,
            "NAME": @name,
            "TOPIC": @topic,
            "MEMBER_COUNT": @member_count
    }
  end

  def self.list_all
    url = "https://slack.com/api/conversations.list"
    param = {token: Channel.token}
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