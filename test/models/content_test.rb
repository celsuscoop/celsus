# encoding: utf-8

require 'test_helper'

class ContentTest < ActiveSupport::TestCase

  test "정상적인 컨텐츠 저장" do
    valid_attrs = {
      title: '이미지',
      body: "본문",
      user_id: 1,
      # :link
      # :file
    }

    content = Content.new(valid_attrs)
    assert content.valid?
  end
end
