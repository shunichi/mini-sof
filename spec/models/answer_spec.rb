require 'spec_helper'

describe Answer do
  it '必要な情報が設定されてると有効' do
    expect(FactoryGirl.build(:answer)).to be_valid
  end

  it 'user_id が指定されていないと無効' do
    expect(FactoryGirl.build(:answer, user_id: nil)).to have(1).errors_on(:user_id)
  end

  it 'question_id が指定されていないと無効' do
    expect(FactoryGirl.build(:answer, question_id: nil)).to have(1).errors_on(:question_id)
  end

  it 'body が空だと無効' do
    expect(FactoryGirl.build(:answer, body: '')).to have(1).errors_on(:body)
  end
end
