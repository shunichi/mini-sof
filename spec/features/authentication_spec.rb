require 'spec_helper'

feature '認証' do
  scenario 'サインアップが成功する' do
    user = FactoryGirl.build(:user)

    expect {
      sign_up user
    }.to change(User, :count).by(1)
  end

  scenario '不正なパラメータでサインアップが失敗する' do
    user = FactoryGirl.build(:invalid_user)

    expect {
      sign_up user
    }.to_not change(User, :count)
  end

  scenario 'ログインしてルートにリダイレクトされる' do
    user = FactoryGirl.create(:user)

    sign_in user

    expect(current_path).to eq root_path
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_link('Log out')
  end

  scenario '不正なパスワードでログインしようとするとエラーになってログイン画面に戻る' do
    user = FactoryGirl.create(:user)
    user.password += 'a'

    sign_in user

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Invalid email or password')
  end

  scenario 'ログアウトしてルートにリダイレクトされる' do
    user = FactoryGirl.create(:user)

    sign_in user
    click_link 'Log out'

    expect(current_path).to eq root_path
    expect(page).to have_content('Signed out successfully')
    expect(page).to have_link('Log in')
  end
end