# encoding: utf-8

require 'spec_helper'

describe Api::V1::SessionsController do
  before :each do*
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'de un usuario' do
      context 'con cuenta activada' do
        let(:user) { create(:user, password: 'password123', email: 'user@gmail.com', account_active: "true") }
        let(:params) { { email: user.email, password: user.password } }
        it 'devuelve el token del usuario' do
          post :create, user: params, format: 'json'
          expect(parse_response(response)['token']).to_not be_nil
        end
    end

    context 'con cuenta inactiva' do
      let(:user) { create(:user, password: 'password123', email: 'user@gmail.com') }
      let(:params) { { email: user.email, password: user.password } }
      it 'devuelve Cuenta inactiva' do
        post :create, user: params, format: 'json'
        expect(parse_response(response)['errors']).to eq(['Cuenta inactiva.'])
      end
    end

    context 'no exitoso' do
      context 'cuando las contraseñas no coinciden' do
        user = FactoryGirl.create(:user, password: "password1")
        let(:params) { { email: user.email, password: "password2" } }
        it 'devuelve error' do
          post :create, user: params, format: 'json'
          expect(parse_response(response)['error']).to eq('authentication error')
        end
      end

        context 'cuando el email no es correcto' do
          user = FactoryGirl.create(:user, email: "user@fing.edu.uy")
          let(:params) { {email: "user2@fing.edu.uy", password: user.password } }
          it 'devuelve un error' do
            post :create, user: params, format: 'json'
            expect(parse_response(response)['error']).to eq('authentication error')
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context 'sign_in/sign_out' do
      let(:user) { create(:user) }
      it 'usuario nil luego del log_out' do
          sign_in user
          expect(subject.current_user).to_not eq(nil)
          sign_out user
          expect(subject.current_user).to eq(nil)
      end
    end

    context 'sign_in - sign_out - sign_in' do
      before(:each) do
        @user = FactoryGirl.create(:user, account_active: "true")
        sign_in @user
        @old_token = @user.authentication_token
      end
      it 'se retornan tokens de autenticacion diferentes' do
          expect(@user).to_not eq(nil)
          delete :destroy, id: @user.authentication_token
          @user.reload
          expect(@user.authentication_token).to_not eq(@old_token)
      end
    end

    context 'exitoso de una sesión de usuario' do
      before(:each) do
        @user = FactoryGirl.create(:user, password: 'password111',  account_active: "true")
        sign_in @user
        delete :destroy, id: @user.authentication_token
      end
      context 'devuelve ok sin contenido' do
        it { expect(response.status).to eq(204) }
      end
    end
  end
end
