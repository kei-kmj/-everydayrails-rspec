require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'responds successfully' do
        sign_in @user
        get :index
        expect(response).to be_successful
      end

      it 'returns a 200 response' do
        sign_in @user
        get :index
        expect(response).to have_http_status '200'
      end
    end

    context '未認証ユーザー' do
      it '302を返す' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'サインイン画面にリダイレクトする' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#create' do
    context '認可されたユーザー' do
      before do
        @user = FactoryBot.create(:user)
      end
      context 'with valid attributes' do
        it 'プロジェクトを追加できる' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect { post :create, params: { project: project_params } }.to change(@user.projects, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'プロジェクトを追加できない' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect { post :create, params: { project: project_params } }.to_not change(@user.projects, :count)
        end
      end
    end

    context '認可されていないユーザー' do
      before do
        @user = FactoryBot.create(:user)
      end

      it '302レスポンスが返る' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'サインイン画面にリダイレクトする' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  describe '#show' do
    context '認可されたユーザー' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it '正常レスポンスを返す' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_successful
      end
    end
    context '認可されていないユーザー' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it 'ダッシュボードにリダイレクトする' do
        get :show, params: { id: @project.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context '認可されたユーザー' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'プロジェクトを更新できる' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'New Project Name'
      end
    end

    context '認可されていないユーザー' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: 'Same Old Name')
      end

      it 'プロジェクトを更新できない' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'Same Old Name'
      end

      it 'サインイン画面にリダイレクトする' do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to redirect_to root_path
      end
    end

    context 'ゲストとして' do
      before do
        @project = FactoryBot.create(:project)
      end

      it '302レスポンスを返す' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'サインイン画面にリダイレクトする' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  describe '# destroy' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      it 'deletes a project' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to change(@user.projects, :count).by(-1)
      end
    end
    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      it 'does not delete the project' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end
      it 'redirects to the dashboard' do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
    context 'as a guest' do
      before do
        @project = FactoryBot.create(:project)
      end
      it 'returns a 302 response' do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status '302'
      end
      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not delete the project' do
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end
    end
  end
end
