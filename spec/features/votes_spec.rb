require 'spec_helper'

feature '投票' do
  given(:user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question, user: user) }
  given!(:answer) { FactoryGirl.create(:answer, question: question)}

  shared_examples '投票可能' do
    scenario 'upvote すると票数が増える', js: true do
      expect {
        find(container).find('.vote-arrow.upvote').click
        wait_for_ajax
      }.to change { votable.votes_score }.by(1)
    end

    scenario 'downvote すると票数が減る', js: true do
      expect {
        find(container).find('.vote-arrow.downvote').click
        wait_for_ajax
      }.to change { votable.votes_score }.by(-1)
    end

    scenario 'vote を逆に変更できる', js: true do
        find(container).find('.vote-arrow.upvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq 1
        find(container).find('.vote-arrow.downvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq -1
        find(container).find('.vote-arrow.upvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq 1
    end

    scenario 'vote の取り消しができる', js: true do
        find(container).find('.vote-arrow.upvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq 1
        find(container).find('.vote-arrow.upvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq 0

        find(container).find('.vote-arrow.downvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq -1
        find(container).find('.vote-arrow.downvote').click
        wait_for_ajax
        expect(votable.votes_score).to eq 0
    end
  end

  feature 'ログインしている場合' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    feature '質問' do
      given(:container) { '.question' }
      given(:votable) { question }
      it_behaves_like '投票可能'
    end

    feature '回答' do
      given(:container) { "#answer_#{answer.id}" }
      given(:votable) { answer }
      it_behaves_like '投票可能'
    end
  end

  shared_examples '投票不可能' do
    scenario '矢印をの class が正しく設定されている' do
      visit question_path(question)
      expect(page).to_not have_css('.vote-arrow.upvote')
      expect(page).to_not have_css('.vote-arrow.downvote')
      expect(page).to have_css('.vote-arrow.disabled')
    end

    scenario '矢印をクリックしても投票されない', js: true do
      visit question_path(question)
      arrows = find(container).all('.vote-arrow')
      expect(arrows.size).to eq 2
      arrows.each do |element|
        element.click
        wait_for_ajax
        expect(votable.votes_score).to eq 0
      end
    end
  end

  feature 'ログインしていない場合' do
    feature '質問' do
      given(:container) { '.question' }
      given(:votable) { question }
      it_behaves_like '投票不可能'
    end

    feature '回答' do
      given(:container) { "#answer_#{answer.id}" }
      given(:votable) { answer }
      it_behaves_like '投票不可能'
    end
  end
end
