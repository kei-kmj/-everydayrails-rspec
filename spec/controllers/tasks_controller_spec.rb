require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, owner: @user)
    @task = @project.tasks.create!(name: 'Test task')
  end

  describe '#show' do
    it 'JSON形式でレスポンスを返す' do
      sign_in @user
      get :show, format: :json, params: { project_id: @project.id, id: @task.id }
      expect(response.content_type).to include 'application/json'
    end
  end

  describe 'create' do
    it 'JSON形式でレスポンスを返す' do
      new_task = { name: 'New test task' }
      sign_in @user
      post :create, format: :json, params: { project_id: @project.id, task: new_task }
      expect(response.content_type).to include 'application/json'
    end
    it '新しいタスクをプロジェクトに追加する' do
      new_task = { name: 'New test task' }
      sign_in @user
      expect do
        post :create, format: :json,
                      params: { project_id: @project.id, task: new_task }
      end.to change(@project.tasks, :count).by(1)
    end

    it '認証を要求する' do
      new_task = { name: 'New test task' }
      expect do
        post :create, format: :json,
                      params: { project_id: @project.id, task: new_task }
      end.to_not change(@project.tasks, :count)
      expect(response).to_not be_successful
    end
  end
end
