#encoding: utf-8
class Audio < Content
  before_validation :adjust_remote_content_id
  before_validation :fetch_audio_info
  validate  :audio_link_check
  validates :link, presence: true
  validate  :source_info_fetched

  def self.remote_audios
    # SoundCloud gem bug, SoundCloud.new가 rails에서는 작동 안함.
    client = Soundcloud.new(client_id: ENV["SOUND_CLOUD_CLIENT_ID"],
                            client_secret: ENV["SOUND_CLOUD_CLIENT_SECRET"],
                            username: ENV["SOUND_CLOUD_USERNAME"],
                            password: ENV["SOUND_CLOUD_PASSWORD"])
    tracks = client.get("/me/tracks")
    tracks.map do |track|
      if Audio.where(remote_content_id: track.id).blank?
        track
      end
    end.compact
  end

  def self.create_from_remote(id, user_id)
    Audio.create(user_id: user_id, remote_content_id: id)
  end

  def self.popular
    # FIXME:  view + download_count 로 로직 수정 필요
    order('view ASC').limit(18)
  end

  def friendly_audios
    friendly_audios = []
    self.tag_list.each do |tag|
      friendly_audios << Audio.where(is_open: true).tagged_with(tag)
    end
    friendly_audios.flatten.uniq - [self]
  end

  def audio_link_check
    if remote_content_id.nil?
      errors.add(:link, "잘못된 링크입니다.")
    end
  end

  def download_url
    if self.source_info["download_url"].present?
      download_url = self.source_info["download_url"] + "?client_id=#{ENV['SOUND_CLOUD_CLIENT_ID']}"
    end
  end

  def thumbnail_url
    self.source_info["artwork_url"]
  end

  def source_info_fetched
    if source_info.blank?
      errors.add(:link, '잘못된 주소이거나, 오디오 정보를 가져오는데 실패했습니다.')
    end
  end

  def license_match(license)
    _license = ''
    if(license.nil?)
      errors.add(:link, "저작권 승인이 안되는 컨텐츠 입니다.")
    elsif (license == 'all-rights-reserved')
      errors.add(:link, "all-rights-reserved 컨텐츠 입니다.")
    elsif (license == 'cc-by')
      _license = Content::COPYRIGHT[0]
    elsif (license == 'cc-by-nc')
      _license = Content::COPYRIGHT[1]
    elsif (license == 'cc-by-nd')
      _license = Content::COPYRIGHT[2]
    elsif (license == 'cc-by-sa')
      _license = Content::COPYRIGHT[3]
    elsif (license == 'cc-by-nc-sa')
      _license = Content::COPYRIGHT[4]
    elsif (license == 'cc-by-nc-nd')
      _license = Content::COPYRIGHT[5]
    elsif (license == 'cc0')
      _license = Content::COPYRIGHT[6]
    end
    _license
  end

  private

  def adjust_remote_content_id
    if link_changed? || (remote_content_id.present? && remote_content_id_changed?)
      self.remote_content_id = _fetch_audio_id
    end
  end

  def fetch_audio_info
    return if not remote_content_id_changed?
    request_url = "http://api.soundcloud.com/tracks/#{remote_content_id}.json?client_id=#{ENV['SOUND_CLOUD_CLIENT_ID']}"
    resp_hash = _fetch_audio_info(request_url)
    if resp_hash.present?
      self.source_info = resp_hash
      self.title = self.source_info["title"] if self.title.blank?
      self.link = self.source_info["permalink_url"]
      _id = self.source_info["id"]

      _copyright = license_match(source_info["license"])
      self.copyright = _copyright if self.copyright.blank?

      self.iframe_html = <<-RUBY
  <iframe width="100%" height="400" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?visual=true&url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F#{_id}&show_artwork=true"></iframe>
  RUBY
      true
    else
      false
    end
  end

  def _fetch_audio_info(request_url)
    resp = RestClient.get(request_url)
    JSON.parse(resp)
  rescue
    {}
  end

  def _fetch_audio_id
    if self.remote_content_id.present?
      remote_content_id
    else
      request_url = "http://soundcloud.com/oembed?format=json&url=#{self.link}"
      respond_hash = _fetch_audio_info(request_url)
      if respond_hash.present?
        respond_hash["html"].split("tracks%2F").last.split("&").first
      end
    end
  end
end