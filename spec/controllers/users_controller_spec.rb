# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do
  let!(:user) { create(:user) }
  describe "PUT 'update/:id'" do
    context 'con datos correctos' do
      let(:params) { { first_name: 'nuevofirst_name', last_name: 'nuevolast_name', phone: '123456677'} }
      it 'se actualiza el first_name, last_name y el phone satisfactoriamente' do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        put :update, id: user.id, user: params, format: 'json'
        expect(response.status).to eq(200)
        expect(user.reload.first_name).to eq(params[:first_name])
        expect(user.reload.last_name).to eq(params[:last_name])
        expect(user.reload.phone).to eq(params[:phone])
      end
    end

    context 'con un token de auth incorrecto' do
      let(:params) { { first_name: 'nuevofirst_name' } }
      it 'no se actualiza la informacion del usuario' do
        request.headers['X-USER-TOKEN'] = user.authentication_token + 'lalal'
        put :update, id: user.id, user: params, format: 'json'
        expect(response.status).to eq(401)
        expect(user.reload.first_name).to_not eq(params[:first_name])
      end
    end

    context 'con datos correctos' do
      let(:params) { { email: 'superpig@ash.com' } }            
      it 'se actualiza el email' do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        put :update, id: user.id, user: params, format: 'json'                
        expect(user.reload.email).to eq(params[:email])
        expect(response.response_code).to eq(200)
      end
    end

    context 'con datos incorrectos' do
      let(:params) { { email: 'formatoEmailIncorrecto' } }            
      it 'no actualiza el email' do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        put :update, id: user.id, user: params, format: 'json'                
        expect(user.reload.email).to_not eq(params[:email])
        expect(response.response_code).to eq(400)
      end
    end
  end

  describe 'GET show' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
    it "devuelve codigo 200" do
      get :show, id: @user.id, format: 'json'
      expect(response.status).to eq(200)
    end
  end
end