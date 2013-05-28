module Lalala::Test::LoginHelper

private

  def login_as_admin!
    AdminUser.create! name: 'Admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password'

    visit('/lalala')
    assert_equal(new_admin_user_session_path, current_path)
    fill_in('Email',    with: 'admin@example.com')
    fill_in('Password', with: 'password')
    click_on('Login')
    assert_equal('/lalala', current_path)
  end

end
