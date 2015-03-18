#encoding: utf-8
class Video < Content
  before_validation :adjust_remote_content_id
  before_validation :fetch_video_info

  validates :remote_content_id, :user_id, presence: true
  validate :unique_remote_content_id
  validate :source_info_fetched

  def self.popular
    # FIXME:  view + download_count 로 로직 수정 필요
    order('view ASC').limit(18)
  end

  def self.remote_videos
    resp = RestClient.get("https://api.vimeo.com/me/videos", {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"})
    hash = JSON.parse(resp)
    hash["data"].map do |video_data|
      video_data_id = video_data["uri"].split("/").last
      RemoteVideo.new(video_data) if Video.where(remote_content_id: video_data_id).blank?
    end.compact
  end

  def self.create_from_remote(video_id, user_id)
    Video.create(user_id: user_id, remote_content_id: video_id)
  end

  def friendly_videos
    friendly_videos = []
    self.tag_list.each do |tag|
      friendly_videos << Video.where(is_open: true).tagged_with(tag)
    end
    friendly_videos.flatten.uniq - [self]
  end

  def license_match(license)
    _license = ''
    if(license.nil?)
      errors.add(:link, "저작권 승인이 안되는 컨텐츠 입니다.")
    elsif (license == 'by')
      _license = Content::COPYRIGHT[0]
    elsif (license == 'by-nc')
      _license = Content::COPYRIGHT[1]
    elsif (license == 'by-nd')
      _license = Content::COPYRIGHT[2]
    elsif (license == 'by-sa')
      _license = Content::COPYRIGHT[3]
    elsif (license == 'by-nc-sa')
      _license = Content::COPYRIGHT[4]
    elsif (license == 'by-nc-nd')
      _license = Content::COPYRIGHT[5]
    elsif (license == 'cc0')
      _license = Content::COPYRIGHT[6]
    end
    _license
  end

  def download_links_hash
    self.source_info["download"]
  end

  def download_url(type_quality)
    download_info = self.download_links_hash.select{|type| type["quality"] == type_quality }.first
    return if download_info.blank?

    expire_at = Time.parse(download_info["expires"])
    if expire_at < Time.now
      _set_video_info( _fetch_video_info )
      self.save
    end
    download_info = self.reload.download_links_hash.select{|type| type["quality"] == type_quality }.first
    download_info["link"]
  end

  def adjust_remote_content_id
    if link_changed?
      self.remote_content_id = self.link.split("/").last
    end
  end

  def fetch_video_info
    return if not remote_content_id_changed?
    resp_hash = _fetch_video_info
    return if resp_hash.blank?
    _set_video_info(resp_hash)
  end

  def unique_remote_content_id
    video = Video.where(remote_content_id: self.remote_content_id).last
    if video.present? && video.id != self.id
      errors.add(:link, "이미 존재하는 비디오 입니다.")
    end
  end

  def source_info_fetched
    if source_info.blank?
      errors.add(:link, '잘못된 주소이거나, 비디오 정보를 가져오는데 실패했습니다.')
    end
  end

  def _fetch_video_info
    request_url =  "https://api.vimeo.com/videos/#{self.remote_content_id}"
    resp = RestClient.get(request_url, {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"} )
    JSON.parse(resp)
  rescue
    {}
  end

  def _set_video_info(resp_hash)
    self.source_info = resp_hash
    string = <<-RUBY
<iframe width="100%" height="400" scrolling="no" frameborder="no" src="//player.vimeo.com/video/#{self.remote_content_id}"></iframe>
RUBY
    self.iframe_html = string
    self.title = self.source_info["name"] if self.title.blank?
    _copyright = license_match(source_info["license"])
    self.copyright = _copyright if self.copyright.blank?
    self.link = self.source_info["link"]
  end

  def thumbnail_url
    source_info['pictures'].select {|p| p['width'] == 295 }.first["link"]
  rescue
    ''
  end
end
