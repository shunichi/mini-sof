require 'spec_helper'

feature 'authentication' do
  scenario 'Sign up' do
    user = FactoryGirl.build(:user)

    expect {
      sign_up user
    }.to change(User, :count).by(1)
  end

  scenario 'Sign up with invalid information' do
    user = FactoryGirl.build(:invalid_user)

    expect {
      sign_up user
    }.to_not change(User, :count)
  end

  scenario 'Log in' do
    user = FactoryGirl.create(:user)

    sign_in user

    expect(current_path).to eq root_path
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Log in with invalid password' do
    user = FactoryGirl.create(:user)
    user.password += 'a'

    sign_in user

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Invalid email or password')
  end

  scenario 'Log out' do
    user = FactoryGirl.create(:user)

    sign_in user
    click_link 'Log out'

    expect(current_path).to eq root_path
    expect(page).to have_content('Signed out successfully')
  end
end