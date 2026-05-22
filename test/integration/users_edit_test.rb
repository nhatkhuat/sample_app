require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
   @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password:"foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:"",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                      email: email,
                                      password:"",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "friendly forwarding only forwards once" do
  # 1. Truy cập vào trang edit để kích hoạt store_location
    get edit_user_path(@user)
    # 2. Đăng nhập lần đầu tiên -> Phải forward về trang edit thành công
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    # 3. 🚨 BÀI TẬP KIỂM TRA: Đảm bảo sau khi forward xong, key này PHẢI bị xóa sạch dưới session
    assert_nil session[:forwarding_url]
    # 4. Giả lập người dùng đăng xuất rồi đăng nhập lại lần thứ hai
    delete logout_path
    log_in_as(@user)
    # 5. Lần này hệ thống PHẢI đưa về trang cá nhân mặc định (show), chứ không được forward về trang edit nữa
    assert_redirected_to @user
  end
end
