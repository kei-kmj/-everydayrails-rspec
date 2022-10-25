# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  it '有効なファクトリーを持つ' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it '名が無ければ無効' do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it '姓が無ければ無効' do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'メアドが無ければ無効' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it '重複したメアドは無効' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'ユーザーのフルネームを文字列で返す' do
    user = FactoryBot.create(:user)
    expect(user.name).to eq 'Alice Summer'
  end
end
