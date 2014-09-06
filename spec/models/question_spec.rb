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
end
