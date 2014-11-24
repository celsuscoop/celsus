#encoding: utf-8
require 'test_helper'
require 'minitest/mock'

class VideoTest < ActiveSupport::TestCase
  setup do
    @valid_attrs = {
      title: '비디오',
      body: "본문",
      user_id: 1,
      link: "https://vimeo.com/110142954",
      copyright: Content::COPYRIGHT[0],
      extra_copyright: false
    }
  end

  test "비디오 정상 등록" do
    # VCR.use_cassette("vimeo01") do
      assert_difference "Video.count", 1 do
        video = Video.new(@valid_attrs)
        video.save

        assert video.iframe_html.present?
        assert video.source_info.present?
        assert video.source_info["pictures"].present? # authorized된 데이터
      end
    # end
  end

  test '제대로된 링크가 들어와야 한다.' do

    # VCR.use_cassette("vimeo02") do
      video = Video.new(@valid_attrs.merge(link: nil))
      assert_equal(false, video.valid?)
      assert video.errors.include?(:link)

      video2 = Video.new(@valid_attrs.merge(link: "http://naver.com"))
      assert_equal(false, video2.valid?)
      assert video2.errors.include?(:link)
    # end
  end

  test 'link가 바뀌면 데이터를 새로 가져온다.' do
    # VCR.use_cassette("vimeo03") do
      video = Video.new(@valid_attrs)
      video.save
      original_iframe_data = video.iframe_html
      video.update(link: 'https://vimeo.com/105306752')
      assert (video.iframe_html != original_iframe_data)
    # end
  end

  test 'link가 안 바뀌면 데이터를 가져오지 않는다.' do
    # VCR.use_cassette("vimeo05") do
      video = Video.create!(@valid_attrs)
      original_iframe_data = video.iframe_html

      dummy_response = { "html" => "내가 불러지면 안돼요." }
      video.stub :_fetch_video_info, dummy_response do
        video.update(title: 'hello')
      end

      assert (video.iframe_html != "내가 불러지면 안돼요.")
      assert_equal(original_iframe_data, video.iframe_html)
    # end
  end


  test 'create_from_remote' do
    video_id = '106886061'
    user_id  = 1
    video = Video.create_from_remote(video_id, user_id)
    assert_equal "GRAPE SODA - short film", video.title
    assert_equal "https://vimeo.com/106886061", video.link
    assert video.source_info["pictures"].present?
  end

  test 'create_from_remote할 때, copyright도 저장된다.' do
    video_id = '110142954'
    user_id  = 1
    assert_difference "Video.count", 1 do
      video = Video.create_from_remote(video_id, user_id)
      assert_equal("CC BY-NC-SA (저작자표시 비영리 동일조건변경허락)", video.copyright)
    end
  end

  test 'video를 업데이트하면 copyright가 없어진다' do
    video_id = '110142954'
    user_id  = 1
    video = Video.create_from_remote(video_id, user_id)
    assert_equal("CC BY-NC-SA (저작자표시 비영리 동일조건변경허락)", video.copyright)

    video.reload
    video.save
    video.reload
    assert_equal("CC BY-NC-SA (저작자표시 비영리 동일조건변경허락)", video.copyright)
  end

  test '중복된 비디오 업로드' do
    video = Video.new(@valid_attrs)
    video.save

    same_video = Video.new(@valid_attrs)

    assert_equal false, same_video.valid?
    assert same_video.errors.include?(:link)
  end

  test "기타 copyright을 등록할 수 있다" do
    changed_attr = @valid_attrs.merge(extra_copyright: true, copyright_extra: 'abc')
    video = Video.new(changed_attr)
    video.save

    video.reload
    assert_equal('abc', video.copyright)
  end

  # test "기타 copyright을 등록할 때는 저작권을 직접 명시해주어야 한다." do
  #   changed_attr = @valid_attrs.merge(extra_copyright: true, copyright_extra: '')
  #   video = Video.new(changed_attr)
  #   assert !video.valid?
  #   assert video.errors.include?(:copyright)
  # end

  test "기타 copyright을 선택하지 않으면 기본값이 나온다." do
    changed_attr = @valid_attrs.merge(extra_copyright: false, copyright_extra: 'kkkk', copyright: "CC0oo")
    video = Video.new(changed_attr)
    video.save

    video.reload
    assert_equal('CC0oo', video.copyright)
  end

  test "리믹스와 함께 원본 콘텐트 아이디를 저장한다" do
    attrs = @valid_attrs.merge(is_remix: true, parent_content_ids: [1, 2])
    video = Video.new(attrs)
    video.save
    assert_equal([1,2], video.parent_content_ids)
  end

  test "리믹스가 아니면 원본 콘텐트를 저장하지 않는다" do
    attrs = @valid_attrs.merge(is_remix: false, parent_content_ids: [1, 2])
    video = Video.new(attrs)
    video.save
    assert_equal([], video.parent_content_ids)
  end

  test "원본 콘텐트 아이디가 변경되면 parent_content_ids값도 변경된다" do
    attrs = @valid_attrs.merge(is_remix: true, parent_content_ids: [1, 2])
    video = Video.new(attrs)
    video.save
    assert_equal([1,2], video.parent_content_ids)
    video.update(parent_content_ids: [2, 3])
    video.save
    assert_equal([2,3], video.parent_content_ids)
  end
end
