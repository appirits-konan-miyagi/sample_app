require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # test "invalid signup information" do
  #   get signup_path
  #   assert_no_difference 'User.count' do
  #     post users_path, params: { user: { name:  "",
  #                                        email: "user@invalid",
  #                                        password:              "foo",
  #                                        password_confirmation: "bar" } }
  #   end
  #   assert_template 'users/new'
  #   # assert_select 'div#<CSS id for error explanation>'
  #   # assert_select 'div.<CSS class for field with error>'
  #   assert_select 'div#flash'
  # end

  # test "invalid signup information" do
  #   get signup_path
  
  #   # 無効なユーザーデータを送信
  #   assert_no_difference 'User.count' do
  #     post users_path, params: { user: { name:  "",
  #                                        email: "user@invalid",
  #                                        password:              "foo",
  #                                        password_confirmation: "bar" } }
  #   end
  
  #   # HTML出力をデバッグ
  #   puts response.body # ここでページ内容を確認
  
  #   # フラッシュメッセージが存在するはず
  #   assert_select 'div#flash'
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
  
    # 無効なユーザーデータを送信
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
  
    # フォームに戻ってくることを確認（newビューを再描画）
    assert_template 'users/new'
  
    # フラッシュメッセージの存在を確認（HTMLの出力内容に依存）
    assert_select 'div.alert.alert-danger' # 修正ポイント
  end
  
  

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
