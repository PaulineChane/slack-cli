require_relative 'test_helper'

describe Recipient do
  describe 'constructor' do
    it "creates a Recipient object" do
      test = Recipient.new("C01BKP7MWNB", "random")
      expect(test).must_be_kind_of Recipient
    end
  end

  describe 'send_message' do

  end
  describe 'self.get' do

  end

  describe 'details' do

  end

  describe 'self.list_all' do

  end
end