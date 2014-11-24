#encoding: utf-8
require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  setup do
    @valid_attrs = {
         title: '오디오',
         body: "본문",
         user_id: 1,
         link: "https://soundcloud.com/forss/flickermood"
       }
  end

  test "정상 오디오 등록" do
    audio = Audio.create(@valid_attrs)
    assert audio.save
  end

  test "제대로 된 링크가 들어와야 한다." do
    #nil 일때
    audio = Audio.new(@valid_attrs.merge(link: nil))
    assert_equal(false, audio.valid?)
    assert audio.errors.include?(:link)

    #이상할때
    audio2 = Audio.new(@valid_attrs.merge(link: 'www.naver.com'))
    assert_equal(false, audio2.valid?)
    assert audio2.errors.include?(:link)
  end

  test "링크가 바뀌면 새로운 데이터를 가져온다. " do
    audio = Audio.create!(@valid_attrs)
    origin_iframe_html = audio.iframe_html

    audio.update(link: 'https://soundcloud.com/50_cent/g-unit-all-about-the-drug-money')

    assert (origin_iframe_html != audio.iframe_html)
  end

  # test "링크에 https:// 가 없으면 붙여준다. " do
  #   audio = Audio.new(@valid_attrs.merge(link: 'soundcloud.com/50_cent/g-unit-all-about-the-drug-money'))
  #   assert audio.valid?
  #   assert audio.save
  # end


end
