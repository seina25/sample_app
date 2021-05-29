# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, "モデルに関するテスト", type: model do
  describe 'モデルのテスト' do
    it "有効な投稿の場合は保存されるか" do
      expect(FactoryBot.build(:list)).to be_valid
    end
  end
end