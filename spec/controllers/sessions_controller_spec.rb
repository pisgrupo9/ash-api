# encoding: utf-8

require 'spec_helper'

describe Api::V1::SessionsController do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
   
    context 'de un usuario' do

      context 'con cuenta activada' do
        let(:password) { 'fernetConCoca' }        
        let(:user)    { create(:user, password: password,  account_active: "true") }
        let(:email)    { user.email }
        let(:params)   { { email: email, password: password, account_active: "true"} }
        
        it 'devuelve el token del usuario' do
          post :create, user: params, format: 'json'       
          expect(parse_response(response)['token']).to_not be_nil
        end
    end
      
      context 'con cuenta inactiva' do
        let(:password) { 'fernetConCoca' }
        let(:user)    { create(:user, password: password) }        
        let(:email)    { user.email }
        let(:params)   { { email: email, password: password, account_active: "true"} }
       
        it 'devuelve Inactive account' do        
          post :create, user: params, format: 'json'       
          expect(parse_response(response)['errors']).to eq(['Inactive account.'])
        end
      end

      context 'no exitoso' do
        context 'cuando las contrasenas no coinciden' do
          let!(:user)    { create(:user, password: "password1", account_active: "true") }
          let(:email)    { user.email }        
          let(:params)   { { email: email, password: "password2", account_active: "true"} }

          it 'devuelve error' do
            post :create, user: params, format: 'json'
            expect(parse_response(response)['error']).to eq('authentication error')
          end
        end

        context 'cuando el email no es correcto' do
          let!(:user)    { create(:user, email: "isaIv@fing.edu.uy", password: "password1", account_active: "true") }
          let(:password) { user.password }        
          let(:params)   { {email: "isaIv2@fing.edu.uy", password: password, account_active: "true"} }

          it 'devuelve un error' do
            post :create, user: params, format: 'json'
            expect(parse_response(response)['error']).to eq('authentication error')
          end
        end
      end
    end
  end

  # describe 'DELETE destroy' do
  #   context 'exitoso de un sesion de un usuario' do
  #     let(:user)    { create(:user, password: "password1", account_active: "true") }      
  #     let(:params)   { {email: "isaIv7@fing.edu.uy", password: "password1", account_active: "true"} }

  #     it 'devuelve el token vacío' do
  #       delete :destroy, user: params, format: 'json'
  #       expect(user.reload.authentication_token).to eq('')
  #     end
  #   end
  # end

  describe "DELETE destroy" do

    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.authentication_token
    end

    it { should respond_with 204 }

  end

end
