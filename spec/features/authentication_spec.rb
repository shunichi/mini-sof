require 'spec_helper'

feature 'authentication' do
  scenario 'Sign up' do
    user = FactoryGirl.build(:user)

    visit root_path
    expect {
      click_link 'Sign up'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_button 'Sign up'
    }.to change(User, :count).by(1)
  end

  scenario 'Sign up with invalid information' do
    user = FactoryGirl.build(:invalid_user)

    visit root_path
    expect {
      click_link 'Sign up'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password_confirmation
      click_button 'Sign up'
    }.to_not change(User, :count)
  end

  scenario 'Log in' do
    user = FactoryGirl.create(:user)

    visit root_path
    click_link 'Log in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(current_path).to eq root_path
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Log in with invalid password' do
    user = FactoryGirl.create(:user)
    user.password += 'a'

    visit root_path
    click_link 'Log in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Invalid email or password')
  end

  scenario 'Log out' do
    user = FactoryGirl.create(:user)

    visit root_path
    click_link 'Log in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    click_link 'Log out'
    expect(current_path).to eq root_path
    expect(page).to have_content('Signed out successfully')
  end
end