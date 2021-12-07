require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without digit' do
    user = User.create(password: 'ABCDEFabcd')

    assert_equal user.errors[:password], ["Change 1 characters of 's password"]
  end

  test 'should not save user without lowerletter' do
    user = User.create(password: 'ABCDEF1234')

    assert_equal user.errors[:password], ["Change 1 characters of 's password"]
  end

  test 'should not save user without upperletter' do
    user = User.create(password: 'abcdef1234')

    assert_equal user.errors[:password], ["Change 1 characters of 's password"]
  end

  test 'should not save user with repeated character sequnce on password' do
    user = User.create(password: 'abcAAABBBcds12')

    assert_equal user.errors[:password], ["Change 2 characters of 's password"]
  end

  test 'should not save user with minimum char password' do
    user = User.create(password: 'Abc1')

    assert_equal user.errors[:password], ["Change 6 characters of 's password"]
  end

  test 'should not save user with maximum char password' do
    user = User.create(password: 'Abc1jfhgkldhg93459328402387')

    assert_equal user.errors[:password], ["Change 11 characters of 's password"]
  end

  test 'should save with valid password' do
    user = User.create(password: 'Abcdef123456', name: 'Viral')

    assert_equal user.persisted?, true
  end
end
