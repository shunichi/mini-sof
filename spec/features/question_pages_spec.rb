feature '質問ページ' do
  scenario '質問の一覧が見られる' do
    questions = 10.times.map { FactoryGirl.create(:question) }

    visit root_path
    save_and_open_page
    questions.each do |q|
      expect(page).to have_content( q.title )
    end
  end

  scenario '質問の内容が見られる' do
    question = FactoryGirl.create(:question)
    visit question_path(question)
    expect(page).to have_content( question.title )
    expect(page).to have_content( question.body )
  end

  scenario '質問が投稿できる' do
    user = FactoryGirl.create(:user)
    attrs = FactoryGirl.attributes_for(:question)

    sign_in user
    expect {
      click_link 'Ask Question'
      fill_in 'question_title', with: attrs[:title]
      fill_in 'question_body', with: attrs[:body]
      click_button 'Save'
    }.to change(Question, :count).by(1)

    expect(page).to have_content( attrs[:title] )
    expect(page).to have_content( attrs[:body] )
  end

  scenario '質問が編集できる' do
    question = FactoryGirl.create(:question)
    new_attrs = FactoryGirl.attributes_for(:question)

    sign_in question.user
    visit question_path(question)
    click_link 'Edit'
    fill_in 'question_title', with: new_attrs[:title]
    fill_in 'question_body', with: new_attrs[:body]
    click_button 'Save'

    question.reload
    expect(question.title).to eq new_attrs[:title]
    expect(question.body).to eq new_attrs[:body]

    expect(page).to have_content( new_attrs[:title] )
    expect(page).to have_content( new_attrs[:body] )
  end

  scenario '質問が削除できる' do
    question = FactoryGirl.create(:question)

    sign_in question.user
    expect {
      visit question_path(question)
      click_link 'Delete'
    }.to change(Question, :count).by(-1)
  end

  scenario '他のユーザーの質問には編集リンクがない' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)

    sign_in user
    visit question_path(question)
    expect(page).to_not have_link('Edit')
  end

  scenario '他のユーザーの質問には削除リンクがない' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)

    sign_in user
    visit question_path(question)
    expect(page).to_not have_link('Delete')
  end

end