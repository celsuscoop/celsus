class Redactor::Picture < ActiveRecord::Base
  mount_uploader :data, RedactorPictureUploader
end
