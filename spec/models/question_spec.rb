require 'spec_helper'

describe Question do
  it "ユーザーIDとタイトルと本文が設定されていれば有効" do
    question = FactoryGirl.build(:question)
    expect(question).to be_valid
  end

  it "ユーザーが指定されいていないと無効" do
    question = FactoryGirl.build(:question, user_id: nil)
    expect(question).to have(1).errors_on(:user_id)
  end

  it "タイトルが空だと無効" do
    question = FactoryGirl.build(:question, title:'')
    expect(question).to have(1).errors_on(:title)
  end

  it "本文が空だと無効" do
    question = FactoryGirl.build(:question, body:'')
    expect(question).to have(1).errors_on(:body)
  end

  it "タイトルが長すぎると無効" do
    question = FactoryGirl.build(:question, title: 'a' * 251)
    expect(question).to have(1).errors_on(:title)
  end

  it "質問を削除すると回答も削除される" do
    question = FactoryGirl.create(:question)
    answer_count = 5
    answers = answer_count.times.map { FactoryGirl.create(:answer, question: question) }

    answers.each do |answer|
      expect(answer).to be_valid
    end
    expect {
      question.destroy
    }.to change(Answer, :count).by(-answer_count)
    answers.each do |answer|
      expect { Answer.find(answer.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
