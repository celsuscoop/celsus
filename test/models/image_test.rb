#encoding: utf-8
require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @valid_attrs = {
       title: '이미지',
       body: "본문",
       user_id: 1,
       link: 'https://imageshack.com/i/mvxyuxj'
      }
    @file_sample = File.new(Rails.root.join('test', 'fixtures', 'sample.png'))
  end

  test "이미지 정상 등록" do
    assert_difference "Image.count", 1 do
      image = Image.create(@valid_attrs)
    end
  end

  test "링크와 파일 아무것도 입력하지 않음" do
    image = Image.new(@valid_attrs.merge(link: nil))
    assert_equal(false, image.valid?)
  end

  test "링크와 파일 둘다 올림" do
    image = Image.new(@valid_attrs.merge(file: @file_sample))
    assert_equal(false, image.valid?)
  end

  test "잘못된 링크 입력" do
    image = Image.new(@valid_attrs.merge(link: 'fail-link'))
    assert_equal(false, image.valid?)
  end

end
