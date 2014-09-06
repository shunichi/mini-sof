require 'spec_helper'

describe User do

  it "Emailアドレスとパスワードとパスワードの確認があれば有効" do
    password = '12345678'
    user = User.new(email: 'abc@abc.com', password: password, password_confirmation: password)
    expect(user).to be_valid
  end

  it "Emailアドレスが空なら無効" do
    user = FactoryGirl.build(:user, email:'')
    expect(user).to have(1).errors_on(:email)
  end

  it "同じEmailが使われていたら無効" do
    user = FactoryGirl.create(:user)
    second_user = User.new(email: user.email, password: user.password, password_confirmation: user.password)
    expect(second_user).to have(1).errors_on(:email)
  end

  it "パスワードがマッチしなければ無効" do
    user = FactoryGirl.build(:user)
    user.password_confirmation += 'a'
    expect(user).to have(1).errors_on(:password_confirmation)
  end

  it "パスワードが8文字未満だと無効" do
    short_password = '1234567'
    user = FactoryGirl.build(:user, password: short_password, password_confirmation: short_password)
    expect(user).to have(1).errors_on(:password)
  end

end
