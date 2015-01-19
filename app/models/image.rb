#encoding: utf-8
class Image < Content
  before_validation :adjust_remote_content_id
  before_validation :fetch_image_info
  validate :check_duplicate

  mount_uploader :file, ImageUploader

  def self.remote_images
    ## 문서: https://docs.google.com/document/d/16M3qaw27vgwuwXqExo0aIC0nni42OOuWu_OGvpYl7dE/pub#h.cibfsb83bh1n
    ## public으로 설정된 것만 나옴.
    resp = RestClient.get("https://api.imageshack.com/v2/user/celsuscoop/images")
    hash = JSON.parse(resp)
    images_data = hash["result"]["images"]
    result = images_data.map do |image_data|
      if Image.where(remote_content_id: image_data["id"]).blank?
        RemoteImage.new(image_data)
      end
    end.compact
  end

  def friendly_images
    friendly_images = []
    self.tag_list.each do |tag|
      friendly_images << Image.where(is_open: true).tagged_with(tag)
    end
    friendly_images.flatten.uniq - [self]
  end

  def adjust_remote_content_id
    if self.link.present? && link_changed?
      self.remote_content_id = self.link.split("/").last
    end
  end

  def check_duplicate
    if self.file.present? && self.link.present?
      errors.add(:link, "하나만 올려야 합니다.")
      errors.add(:file, "하나만 올려야 합니다.")
    end
  end

  def download_url
    self.iframe_html
  end

  def iframe_html
    if file.present?
      file.url
    else
      read_attribute(:iframe_html)
    end
  end

  def self.popular
    # FIXME:  view + download_count 로 로직 수정 필요
    order('view ASC').limit(18)
  end

  def thumbnail_url
    if self.file.present?
      self.file.url(:thumb)
    else
      resized_remote_url(240, 135)
    end
  end

  def middle_size_url
    if self.file.present?
      self.file.url(:middle)
    else
      resized_remote_url(575, 381)
    end
  end

  def large_size_url
    if self.file.present?
      self.file.url(:large)
    else
      resized_remote_url(1006, 400)
    end
  end

  def resized_remote_url(width, height)
    server = self.source_info["result"]["server"]
    filename = self.source_info["result"]["filename"]
    thumbnail = "https://imagizer.imageshack.us/#{width}x#{height}/#{server}/#{filename}"
  end

  def self.create_from_remote(remote_content_id, user_id)
    image = Image.new(user_id: user_id, remote_content_id: remote_content_id)
    image.save
    image
  end

  private

  def fetch_image_info
    return if not remote_content_id_changed?
    if file.blank? && remote_content_id.present? && remote_content_id_changed?
      request_url = "https://api.imageshack.com/v2/images/#{self.remote_content_id}?api_key=#{ENV['IMAGE_SHAKER_API_KEY']}"
      resp_hash = _fetch_image_info(request_url)
      if resp_hash.present?
        self.title = resp_hash["result"]["filename"] if self.title.blank?
        self.link  = "https://imageshack.com/i/#{resp_hash['result']['id']}" if self.link.blank?
        self.source_info = resp_hash
        self.iframe_html = 'http://' + resp_hash["result"]["direct_link"]
      else
        errors.add(:link, "이미지를 가져올 수 없습니다. 주소를 다시한번 확인해 주세요.")
      end
    end
  end

  def _fetch_image_info(request_url)
    resp =  RestClient.get(request_url)
    JSON.parse(resp)
  rescue
    {}
  end
end
