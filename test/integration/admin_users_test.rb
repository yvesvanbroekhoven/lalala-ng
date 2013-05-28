require File.dirname(__FILE__) + '/../test_helper'

class AdminUsersTest < ActionDispatch::IntegrationTest

  def setup
    login_as_admin!
  end

  test 'list users' do
    click_on('Admin Users')
    assert page.has_text?('admin@example.com')
  end

  test 'create user' do
    click_on('Admin Users')
    click_on('New Admin User')
    assert_equal('/lalala/admin_users/new', current_path)

    fill_in('Name',                              with: 'Mr. Manager')
    fill_in('Email',                             with: 'manager@example.com')
    fill_in('admin_user[password]',              with: 'foobarbaz!')
    fill_in('admin_user[password_confirmation]', with: 'foobarbaz!')
    click_on('Create Admin user')
    assert_equal('/lalala/admin_users/2', current_path)

    assert page.has_text?('manager@example.com')
    assert page.has_text?('Mr. Manager')
  end

end
