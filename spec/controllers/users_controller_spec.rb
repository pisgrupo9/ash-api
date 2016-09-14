# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do
 
  let!(:user1) { create(:user, account_active: 'true', permissions: 'default_user') }
  let!(:user2) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let!(:user3) { create(:user, account_active: 'true', permissions: 'adopters_edit') }

  describe "PUT 'update/:id'" do
    context 'con datos correctos' do
      let(:params) { { first_name: 'nuevofirst_name', last_name: 'nuevolast_name'} }

      it 'retorna operacion satisfactoria con codigo 200' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: params, format: 'json'
        expect(response.status).to eq(200)
      end

      it 'se actualiza el first_name y last_name satisfactoriamente' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: params, format: 'json'
        expect(user1.reload.first_name).to eq(params[:first_name])
        expect(user1.reload.last_name).to eq(params[:last_name])
      end
    end

    context 'con un token de auth incorrecto' do
      let(:params) { { first_name: 'nuevofirst_name' } }

      it 'retorna usuario sin autorizacion con codigo 401' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token + 'lalal'
        put :update, id: user1.id, user: params, format: 'json'
        expect(response.status).to eq(401)
      end

      it 'no se actualiza la informacion del usuario' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token + 'lalal'
        put :update, id: user1.id, user: params, format: 'json'
        expect(user1.reload.first_name).to_not eq(params[:first_name])
      end
    end

    context 'atributos no permitidos para modificarse' do
      let(:paramMail) { { email: 'superPig@ash.com' } }
      let(:paramTel) { { phone: '27458965' } }

      it 'no se actualiza el email ' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: paramMail, format: 'json'
        expect(user1.reload.email).to_not eq(paramMail[:email])
      end

      it 'no se actualiza el telefono ' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: paramTel, format: 'json'
        expect(user1.reload.phone).to_not eq(paramTel[:phone])
      end
    end
  end

  describe 'GET #index' do
    it 'retorna operacion satisfactoria con codigo 200' do
      sign_in user1
      get :index, format: :json
      expect(response.status).to eq(200)
    end

    it 'retorna los usuarios registrados del sistema' do
      sign_in user1
      get :index, format: :json
      expect(assigns(:users)).to eq([user1,user2,user3])
    end
  end

  describe 'GET #show' do
    it "retorna operacion exitosa" do
      sign_in user1
      get :show, id: user1, format: :json
      expect(response.status).to eq(200)
    end

    it "se obtiene la informacion de un usuario especifico" do
      sign_in user1
      get :show, id: user1, format: :json
      expect(parse_response(response)).to eq(user1.as_json(only: [:id, :email, :first_name, :last_name, :phone, :account_active, :permissions]))
    end
  end

  describe 'GET #isanimalsedit' do
    it "retorna codigo 403 con un usuario que tiene permisos basicos" do
      sign_in user1
      get :isanimalsedit
      expect(response.status).to eq(403)
    end

    it "retorna codigo 403 con un usuario que tiene permiso de editar adoptantes" do
      sign_in user3
      get :isanimalsedit
      expect(response.status).to eq(403)
    end

    it "retorna operacion exitosa con un usuario que tiene permiso de editar animales" do
      sign_in user2
      get :isanimalsedit
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #isadoptersedit' do
    it "retorna codigo 403 con un usuario que tiene permisos basicos" do
      sign_in user1
      get :isadoptersedit
      expect(response.status).to eq(403)
    end

    it "retorna operacion exitosa con un usuario que tiene permiso de editar adoptantes" do
      sign_in user3
      get :isadoptersedit
      expect(response.status).to eq(200)
    end

    it "retorna codigo 403 con un usuario que tiene permiso de editar animales" do
      sign_in user2
      get :isadoptersedit
      expect(response.status).to eq(403)
    end
  end

  describe 'GET #isdefaultuser' do
    it "retorna operacion exitosa con un usuario que tiene permisos basicos" do
      sign_in user1
      get :isdefaultuser
      expect(response.status).to eq(200)
    end

    it "retorna codigo 403 con un usuario que tiene permiso de editar adoptantes" do
      sign_in user3
      get :isdefaultuser
      expect(response.status).to eq(403)
    end

    it "retorna codigo 403 con un usuario que tiene permiso de editar animales" do
      sign_in user2
      get :isdefaultuser
      expect(response.status).to eq(403)
    end
  end
end
