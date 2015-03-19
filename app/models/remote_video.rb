require 'ostruct'

class RemoteVideo < OpenStruct
  attr_accessor :already_taken

  def initialize(*args)
    @already_taken = false
    super
  end

  def already_taken?
    @already_taken
  end

  def thumbnail_url
    i = [pictures.count/2, 0].max
    pictures[i]["link"]
  end

  def license_ko
    if self.license.nil?
      "저작권 승인이 안된 컨텐츠 입니다."
    else
      self.license
    end
  end
end