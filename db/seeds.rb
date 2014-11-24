# encoding: utf-8

su = User.create!(name: 'su', email: 'su@celsus.com', password: ENV['PASSWORD'], password_confirmation: ENV['PASSWORD'], role: 'su')
admin = User.create!(name: 'admin', email: 'admin@celsus.com', password: ENV['PASSWORD'], password_confirmation: ENV['PASSWORD'], role: 'admin')
contributor = User.create!(name: 'contributor', email: 'contributor@celsus.com', password: ENV['PASSWORD'], password_confirmation: ENV['PASSWORD'], role: 'contributor')
guest = User.create!(name: 'guest', email: '123@celsus.com', password: ENV['PASSWORD'], password_confirmation: ENV['PASSWORD'], role: 'guest')

# 카테고리
["공지사항", "셀수스이야기"].each do |name|
  Category.create(name: name)
end