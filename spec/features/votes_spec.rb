require 'spec_helper'

feature '投票' do
  given(:user) { FactoryGirl.create(:user) }
  given(:question) { FactoryGirl.create(:question, user: user) }

  feature 'ログインしている場合' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'upvote すると票数が増える', js: true do
      expect {
        find('.question-upvote').click
        wait_for_ajax
      }.to change { question.vote_sum }.by(1)
    end

    scenario 'downvote すると票数が減る', js: true do
      expect {
        find('.question-downvote').click
        wait_for_ajax
      }.to change { question.vote_sum }.by(-1)
    end

    scenario 'vote の取り消しができる', js: true do
        find('.question-upvote').click
        wait_for_ajax
        expect(question.vote_sum).to eq 1
        find('.question-upvote').click
        wait_for_ajax
        expect(question.vote_sum).to eq 0

        find('.question-downvote').click
        wait_for_ajax
        expect(question.vote_sum).to eq -1
        find('.question-downvote').click
        wait_for_ajax
        expect(question.vote_sum).to eq 0
    end
  end

  feature 'ログインしていない場合' do
    scenario 'vote できない' do
      visit question_path(question)
      expect(page).to_not have_css('.question-upvote')
      expect(page).to_not have_css('.question-downvote')
      expect(page).to have_css('.question-vote-disabled')
    end
  end
end
