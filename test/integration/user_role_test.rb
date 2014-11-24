# encoding: utf-8
require 'test_helper'

class UserRoleTest < ActionDispatch::IntegrationTest
  setup do
    @su = User.create!(name: 'admin', email: 'su@celsus.com', password: '123123123', password_confirmation: '123123123', role: 'su')
    @admin = User.create!(name: 'admin', email: 'admin@celsus.com', password: '123123123', password_confirmation: '123123123', role: 'admin')
  end

  test "su 는 유저 정보를 변경 할 수 있다." do
    login_as(@su)
    visit edit_admin_user_path(@su)
  end

  test "su 가 아니면 유저 정보를 변경 할 수 없다." do
    login_as(@admin)
    visit admin_users_path
    assert_equal false, page.has_content?("수정")

    visit edit_admin_user_path(@admin)
    # 홈 url 체크
  end

  test "admin 은 컨텐츠 정보를 변경 할 수 있다." do
    #...
  end
end