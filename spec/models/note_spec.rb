require 'rails_helper'

RSpec.describe Note, type: :model do

  before do
    @user = User.create(first_name: "Bob", last_name: "Jonson", email: "test@example.com", password: "password")
    @project = @user.projects.create(name: "Test Project",)

  end

  it "ユーザー、プロジェクト、メッセージがあること" do
    note = Note.new(message: "This is a sample note.",
                    user: @user,
                    project: @project,
    )
    expect(note).to be_valid
  end

  it "メッセージが無ければ無効" do
    note = Note.new(message: nil,
                    user: @user,
                    project: @project,
    )
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end
  describe "search message for a term" do
    before do
      @note1 = @project.notes.create(message: "This is the first note.", user: @user)
      @note2 = @project.notes.create(message: "This is the second note.", user: @user)
      @note3 = @project.notes.create(message: "First, prehear the oven.", user: @user)
    end
    context "when a match is found" do
      it "検索文字列に一致するメモを返す" do

        expect(Note.search("first")).to include(@note1, @note3)
        expect(Note.search("first")).to_not include(@note2)

      end

      context "when no match is found" do
        it "検索結果が1件も見つからないときは空のコレクションを返す" do

          expect(Note.search("message")).to be_empty
        end
      end
    end
  end
end
