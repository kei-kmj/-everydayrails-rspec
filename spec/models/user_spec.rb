require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a first name, last name, email, and password" do
    user = User.new(first_name: "Alice", last_name: "smith", email: "alice@example.com", password: "password")
    expect(user).to be_valid
  end
  it "名が無ければ無効" do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  it "姓が無ければ無効" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  it "メアドが無ければ無効" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  it "重複したメアドは無効" do
    User.create(first_name: "Bob", last_name: "Jonson", email: "test@example.com", password: "password")
    user = User.new(first_name: "Carol", last_name: "Brown", email: "test@example.com", password: "password")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  it "ユーザーのフルネームを文字列で返す" do
    user = User.new(first_name: "Bob", last_name: "Jonson", email: "test@example.com", password: "password")
    expect(user.name).to eq "Bob Jonson"
  end
end
