require 'ostruct'

class RemoteImage < OpenStruct
  def thumbnail_url
    "https://imagizer.imageshack.us/240x135/#{server}/#{filename}"
  end

  def license_ko
    "저작권 정보가 없습니다."
  end
end