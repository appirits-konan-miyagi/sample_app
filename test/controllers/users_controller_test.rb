require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    # 別のユーザーでログイン
    log_in_as(@other_user)

    # @other_user は admin == false のはず
    assert_not @other_user.admin?

    # admin 属性を変更しようとする PATCH リクエスト
    patch user_path(@other_user), params: {
      user: {
        password: 'password',
        password_confirmation: 'password',
        admin: true # admin を true に変更しようとする
      }
    }

    # データベースから@other_userを再読み込みし、adminがtrueに変更されていないことを確認
    @other_user.reload # データベースから最新の情報を取得
    assert_not @other_user.admin? # admin が変更されていないこと
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
