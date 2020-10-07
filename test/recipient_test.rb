require_relative 'test_helper'

describe Recipient do
  describe 'constructor' do
    it "creates a Recipient object" do
      test = Recipient.new(slack_id: "C01BKP7MWNB",name: "random")
      expect(test).must_be_kind_of Recipient
      expect(test.slack_id).must_equal "C01BKP7MWNB"
      expect(test.name).must_equal "random"
    end
  end

  describe 'send_message' do
    # ADD TESTS DURING WAVE 3
  end
  describe 'self.get' do
    it 'raises a SlackApiError if parameter input is invalid' do
      VCR.use_cassette("Recipient.get") do
        url = "https://slack.com/api/conversations.list"
        param = {token: 'blah'}
        expect do
          Recipient.get(url, param)
        end.must_raise SlackApiError
        expect do
          Recipient.get("https://slack.com/api/monkeys", {token: ENV['SLACK_TOKEN']})
        end.must_raise SlackApiError
      end
    end

    it 'returns a response for url and legal params' do
      VCR.use_cassette("Recipient.get") do
        url = "https://slack.com/api/conversations.list"
        param = {token: ENV['SLACK_TOKEN']}
        response = Recipient.get(url, param)
        expect(response["ok"]).must_equal true
      end
    end
  end
  describe 'details' do
    it "raises NotImplementedError if called from Recipient" do
      test = Recipient.new(slack_id: "C01BKP7MWNB", name: "random")
      expect do
        test.details
      end.must_raise NotImplementedError
    end
  end

  describe 'self.list_all' do
    it "raises NotImplementedError if called from Recipient" do
      expect do
        Recipient.list_all
      end.must_raise NotImplementedError
    end
  end
end