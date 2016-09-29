# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do

  let!(:user1) { create(:user, phone: '099123456', account_active: 'true', permissions: 'default_user') }
  let!(:user2) { create(:user, phone: '099123456', account_active: 'true', permissions: 'animals_edit') }
  let!(:user3) { create(:user, phone: '099123456', account_active: 'true', permissions: 'adopters_edit') }

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
      let(:paramTel) { { phone: '099123456' } }

      it 'no se actualiza el email ' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: paramMail, format: 'json'
        expect(user1.reload.email).to_not eq(paramMail[:email])
      end

      it 'no se actualiza el telefono ' do
        request.headers['X-USER-TOKEN'] = user1.authentication_token
        put :update, id: user1.id, user: paramTel, format: 'json'
        expect(user1.reload.phone).to eq(paramTel[:phone])
      end
    end
  end

  describe 'GET #show' do
    it "retorna operacion exitosa" do
      sign_in user1
      get :show, id: user1, format: 'json'
      expect(response.status).to eq(200)
    end

    it "se obtiene la informacion de un usuario especifico" do
      sign_in user1
      get :show, id: user1, format: 'json'
      expect(parse_response(response)).to eq(user1.as_json(only: [:id, :email, :first_name, :last_name, :phone, :account_active, :permissions]))
    end
  end
end
