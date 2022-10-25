# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @joe = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joe@example.com', password: 'password'
    )

    @dave = User.create(
      first_name: 'Dave',
      last_name: 'Tester',
      email: 'dave@example.com', password: 'password'
    )
  end

  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  it '締め切り日が過ぎていれば遅延している' do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  it '締め切り日が今日ならばオンスケジュール' do
    project = FactoryBot.create(:project, :due_today)

    expect(project).to_not be_late
  end

  it '締め切り日が未来ならばオンスケジュール' do
    project = FactoryBot.create(:project, :due_tomorrow)

    expect(project).to_not be_late
  end

  it 'プロジェクト名は空白にできない' do
    nil_project = @joe.projects.create(name: nil)
    nil_project.valid?
    expect(nil_project.errors[:name]).to include("can't be blank")
  end

  context 'Duplicate project name' do
    it 'ユーザー単位ではプロジェクト名は重複できない' do
      @joe.projects.create(name: 'Test Project')
      new_project = @joe.projects.build(
        name: 'Test Project'
      )

      new_project.valid?
      expect(new_project.errors[:name]).to include('has already been taken')
    end

    it '異なるユーザーはプロ時ジェクト名が重複しても良い' do
      @joe.projects.create(name: 'Test Project')

      other_project = @dave.projects.build(
        name: 'Test Project'
      )
      expect(other_project).to be_valid
    end
  end
end
