#encoding: utf-8
require 'rest_client'
require 'json'
# require 'google/api_client'
# require 'google/api_client/auth/installed_app'

class Content < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :user
  has_many :user_activities
  has_many :warnings, dependent: :destroy

  validates :title, presence: true
  # validates :copyright, presence: true

  serialize :source_info
  serialize :parent_content_ids

  after_initialize do
    if parent_content_ids.nil?
      parent_content_ids = []
    end
  end

  before_validation do
    if self.is_remix == false
      self.parent_content_ids = []
    end
  end

  before_validation :adjust_copyright

  attr_accessor :copyright_extra
  COPYRIGHT = ["CC BY (저작자표시)", "CC BY-NC (저작자표시 비영리)", "CC BY-ND (저작자표시 변경금지)", "CC BY-SA (저작자표시 동일조건변경허락)", "CC BY-NC-SA (저작자표시 비영리 동일조건변경허락)", "CC BY-NC-ND (저작자표시 비영리 변경금지)", "CC0 (저작권 포기)", "public domain (저작권이 소멸된 저작물)" ]

  COPYRIGHT_IMAGE_HASH = {
    Content::COPYRIGHT[0] => [
      "https://i.creativecommons.org/l/by/4.0/88x31.png",
      "http://creativecommons.org/licenses/by/4.0/"
      ],
    Content::COPYRIGHT[1] => [
      "https://i.creativecommons.org/l/by-nc/4.0/88x31.png",
      "http://creativecommons.org/licenses/by-nc/4.0/"
      ],
    Content::COPYRIGHT[2] => [
      "https://i.creativecommons.org/l/by-nd/4.0/88x31.png",
      "http://creativecommons.org/licenses/by-nd/4.0/"
      ],
    Content::COPYRIGHT[3] => [
      "https://i.creativecommons.org/l/by-sa/4.0/88x31.png",
      "http://creativecommons.org/licenses/by-sa/4.0/"
      ],
    Content::COPYRIGHT[4] => [
      "https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png",
      "http://creativecommons.org/licenses/by-nc-sa/4.0/"
      ],
    Content::COPYRIGHT[5] => [
      "https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png",
      "http://creativecommons.org/licenses/by-nc-nd/4.0/"
      ],
    Content::COPYRIGHT[6] => [
      "http://i.creativecommons.org/p/zero/1.0/88x31.png",
      "https://creativecommons.org/choose/zero/"
      ],
    Content::COPYRIGHT[7] => [
      "http://i.creativecommons.org/p/mark/1.0/88x31.png",
      "https://creativecommons.org/choose/mark/"
      ]
  }

  def copy_right_image_url
    if self.extra_copyright
      self.copyright
    else
      COPYRIGHT_IMAGE_HASH[self.copyright].try(:[], 0)
    end
  end

  def copy_right_licence_info_url
    if self.extra_copyright
      '#'
    else
      COPYRIGHT_IMAGE_HASH[self.copyright].try(:[], 1)
    end
  end

  def adjust_copyright
    if extra_copyright
      self.copyright = copyright_extra
    else
      self.copyright = self.copyright
    end
  end

  def self.in_copyright(copyright)
    if copyright.present?
      where(copyright: copyright)
    else
      all
    end
  end

  def self.in_query(q)
    if q.present?
      where('title like ? or body like ? or copyright like ?',"%#{q}%","%#{q}%","%#{q}%")
    else
      all
    end
  end

  def self.in_title(title)
    if title.present?
      where('title like ?',"%#{title}%")
    else
      all
    end
  end

  def self.in_body(body)
    if body.present?
      where('body like ?',"%#{body}%")
    else
      all
    end
  end

  def self.in_author(author)
    if author.present?
      joins(:user).where("users.name like ?", "%#{author}%")
    else
      all
    end
  end

  def self.in_owner(owner_name)
    if owner_name.present?
      where('owner_name like ?',"%#{owner_name}%")
    else
      all
    end
  end

  def self.in_open(open)
    if open.present?
      open = (open == "true")
      where(is_open: open)
    else
      all
    end
  end

  def self.in_main(main)
    if main.present?
      main = (main == "true")
      where(main: main)
    else
      all
    end
  end

  def self.in_remix(remix)
    if remix.present?
      remix = (remix == "true")
      where(is_remix: remix)
    else
      all
    end
  end

  def increase_download_count(user)
    UserActivity.create(user_id: user.id, content_id: self.id)
    self.download_count += 1
    self.save
  end

  def self.popular
    # FIXME:  view + download_count 로 로직 수정 필요
    order('view ASC').limit(18)
  end

  def remix_ko
    self.is_remix? ? 'O' : 'X'
  end

  # def update_sns
    # facebook
    # me = FbGraph::User.me(ENV['YOUR_ACCESS_TOKEN'])
    # me = me.fetch
    # me.feed!(
    #   :message => '셀수스에 새로운 콘텐츠가 업데이트되었습니다.',
    #   :picture => self.thumbnail_url,
    #   :link => 'https://www.facebook.com/celsuscoop',
    #   :name => self.title,
    #   :description => self.body
    # )

    # twitter
    # client = TwitterOAuth::Client.new(
    #   :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
    #   :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
    #   :token => ENV['TWITTER_ACCESS_TOKEN'],
    #   :secret => ENV['TWITgit giTER_ACCESS_SECRET']
    # )
    # client.update('셀수스에 새로운 콘텐츠가 업데이트되었습니다.' + self.link)

    # google
    # client = Google::APIClient.new(
    #   :application_name => 'celsus',
    #   :application_version => '1.0.0'
    # )
    # plus = client.discovered_api('plus')

    # flow = Google::APIClient::InstalledAppFlow.new(
    #   :client_id => ENV['GOOGLE_CLIENT_ID'],
    #   :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
    #   :scope => ['https://www.googleapis.com/auth/plus.me']
    #   # :redirect_uri => 'https://celsus.ufosoft.net/oauth2callback'
    # )
    # client.authorization = flow.authorize

    # # moment = {
    # #   "type": "http://schemas.google.com/AddActivity",
    # #   "target": {
    # #     "id": "target-id-1"
    # #     "url": "https://developers.google.com/+/plugins/snippet/examples/thing"
    # #     "name": "The Google+ Platform",
    # #     "description": "A page that describes just how awesome Google+ is!"
    # #   }
    # # }
    # result = client.execute(
    #   :api_method => plus.momenti.insert,
    #   :parameters => {'collection' => 'vault', 'userId' => 'me', 'body' => moment}
    # )
  # end

  def check_owner_url
    self.owner_url = "http://"+ self.owner_url unless self.owner_url.include? "http://"
    self.owner_url
  end
end
