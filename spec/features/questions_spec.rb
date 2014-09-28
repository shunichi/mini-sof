require 'spec_helper'

feature '質問ページ' do

  feature '一覧ページ' do
    scenario '１ページに収まる場合、全ての質問が表示されている' do
      question_count = Kaminari.config.default_per_page
      questions = question_count.times.map { FactoryGirl.create(:question) }

      visit root_path
      questions.each do |q|
        expect(page).to have_content( q.title )
      end
    end

    scenario '正しくページ分割されている' do
      page_count = 3
      question_count = Kaminari.config.default_per_page * page_count
      question_count.times.map { FactoryGirl.create(:question) }

      page_count.times.each do |p0|
        displayed_page_no = p0 + 1

        visit paged_questions_path(page: displayed_page_no)

        page_count.times.each do |p1|
          page_no = p1 + 1

          questions = Question.order(updated_at: :desc).page(page_no)
          questions.each do |q|
            if displayed_page_no == page_no
              expect(page).to have_selector( 'h3', text: q.title )
            else
              expect(page).to_not have_selector( 'h3', text: q.title )
            end
          end
        end
      end
    end

    shared_examples 'ソート' do |order_type, order_key|
      scenario 'ソートされている' do
        question_count = Kaminari.config.default_per_page
        question_count.times.map { FactoryGirl.create(:question) }

        visit root_path(sort: order_type)

        questions = Question.order(order_key => :desc).page(1)

        expect(page.all('.question-summary h3').map(&:text)).to eq(questions.map(&:title))
      end
    end

    feature '更新時間ソート' do
      it_behaves_like 'ソート', 'active', :updated_at
    end

    feature '新着順ソート' do
      it_behaves_like 'ソート', 'newest', :created_at
    end

    feature '得票順ソート' do
      it_behaves_like 'ソート', 'votes', :cached_votes_score
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
      click_link '質問する'
      fill_in 'question_title', with: attrs[:title]
      fill_in 'question_body', with: attrs[:body]
      click_button '保存'
    }.to change(Question, :count).by(1)

    expect(page).to have_content( attrs[:title] )
    expect(page).to have_content( attrs[:body] )
  end

  scenario '質問が編集できる' do
    question = FactoryGirl.create(:question)
    new_attrs = FactoryGirl.attributes_for(:question)

    sign_in question.user
    visit question_path(question)
    click_link '編集'
    fill_in 'question_title', with: new_attrs[:title]
    fill_in 'question_body', with: new_attrs[:body]
    click_button '保存'

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
      click_link '削除'
    }.to change(Question, :count).by(-1)
  end

  scenario '他のユーザーの質問には編集リンクがない' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)

    sign_in user
    visit question_path(question)
    expect(page).to_not have_link('編集')
  end

  scenario '他のユーザーの質問には削除リンクがない' do
    question = FactoryGirl.create(:question)
    user = FactoryGirl.create(:user)

    sign_in user
    visit question_path(question)
    expect(page).to_not have_link('削除')
  end

end