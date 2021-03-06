require 'spec_helper'

feature '回答' do
  scenario '質問ページに回答が表示される' do
    question = FactoryGirl.create(:question)
    answers = 5.times.map { FactoryGirl.create(:answer, question: question) }

    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

  scenario '質問に回答できる' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)

    sign_in user

    visit question_path(question)
    expect {
      fill_in 'answer_body', with: 'あああ'
      click_button '回答する'
    }.to change(Answer, :count).by(1)
  end

  scenario '何も書かずに回答するとエラー' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:answer, user: user, question: question)

    sign_in user

    visit question_path(question)
    expect {
      click_button '回答する'
    }.to_not change(Answer, :count)
    expect(page).to have_content('入力にエラーがあるため回答できませんでした')
  end

  scenario '自分の回答にのみ編集や削除のリンクが存在する' do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)
    others_answer = FactoryGirl.create(:answer, question: question)

    sign_in answer.user

    visit question_path(question)
    expect(page).to have_css("#answer_#{answer.id} .answer-edit-link")
    expect(page).to have_css("#answer_#{answer.id} .answer-delete-link")
    expect(page).to_not have_css("#answer_#{others_answer.id} .answer-edit-link")
    expect(page).to_not have_css("#answer_#{others_answer.id} .answer-delete-link")
  end

  scenario '自分の回答の削除ができる' do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)

    sign_in answer.user

    visit question_path(question)
    expect {
      find("#answer_#{answer.id}").click_link '削除'
    }.to change(Answer, :count).by(-1)
  end

  scenario '自分の回答の編集ができる', js: true do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)
    new_answer_text = Faker::Lorem.paragraph

    sign_in answer.user

    visit question_path(question)
    find("#answer_#{answer.id}").click_link '編集'
    find("#answer_#{answer.id}").fill_in 'answer_body', with: new_answer_text
    find("#answer_#{answer.id}").click_button '保存'
    wait_for_ajax

    answer.reload
    expect(answer.body).to eq new_answer_text
  end

  scenario '自分の質問に対する回答を承認できる', js: true do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)

    sign_in question.user

    visit question_path(question)
    find("#answer_#{answer.id} .accept-link").click
    wait_for_ajax

    question.reload
    expect(question.accepted_answer).to eq answer
  end

  scenario '自分の質問に対する回答の承認を取り消せる', js: true do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)
    question.accepted_answer = answer
    question.save!

    sign_in question.user

    visit question_path(question)
    find("#answer_#{answer.id} .accept-link").click
    wait_for_ajax

    question.reload
    expect(question.accepted_answer).to be_nil
  end

  scenario '他人の質問に対する回答は承認のリンクはない', js: true do
    question = FactoryGirl.create(:question)
    answer = FactoryGirl.create(:answer, question: question)
    user = FactoryGirl.create(:user)

    sign_in user

    visit question_path(question)
    expect(page).to_not have_css("#answer_#{answer.id} .accept-link")
  end

end
