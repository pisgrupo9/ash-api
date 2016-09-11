require 'spec_helper'
require 'json'

describe Api::V1::RegistrationsController, type: :controller do
  let!(:user)  { create(:user) }
  let!(:admin)  { create(:admin) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "POST 'users/'" do
    let(:first_name)  { 'Isabella' }
    let(:last_name)  { 'Test' }
    let(:email)  { 'juana@example.com' }
    let(:password)  { 'password' }
    let(:password_confirmation)  {'password'}

    let(:attrs) do
      {
        first_name: first_name,
        last_name: last_name,
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    end
    context 'crea una cuenta exitosamente' do
      
      it 'devuelve un 200 OK' do
        post :create, user: attrs, format: 'json'
        expect(response.status).to eq(200)
      end

      it 'devuelve un nuevo usurio creado' do
        post :create, user: attrs, format: 'json'
        new_user = User.find_by_email('juana@example.com')
        expect(new_user).to_not be_nil
      end
    end

    context 'cuando el email no es correcto' do
      let(:email)  { 'falso_email' }

      it 'no crea la cuenta del usuario' do
        expect { post :create, user: attrs, format: 'json' }.not_to change { User.count }
      end

      it 'devuelve un 400 bad request' do
        post :create, user: attrs, format: 'json'
        expect(response.response_code).to eq(400)
      end

      context 'cuando el email es vacío' do
        let(:email)  { '' }

        it 'no crea la cuenta del usuario' do
          expect { post :create, user: attrs, format: 'json' }.not_to change { User.count }
        end

        it 'devuelve un 400 bad request' do
          post :create, user: attrs, format: 'json'
          expect(response.response_code).to eq(400)
        end
      end
    end

    context 'cuando la contraseña no es correcta' do

      context 'porque es muy corta' do
        let(:password)  { 'pass' }
        let(:password_confirmation) { 'pass' }

        let(:new_user)  { User.find_by_email('amiguitos@test.com') }

        it 'no crea la cuenta del usuario' do
          post :create, user: attrs, format: 'json'
          expect(new_user).to be_nil
        end

        it 'devuelve un 400 bad request' do
          post :create, user: attrs, format: 'json'
          expect(response.response_code).to eq(400)
        end
      end

      context 'cuando la contraseña es vacía' do
        let(:password)  { '' }
        let(:new_user)  { User.find_by_email('amiguitos@test.com') }

        it 'no crea la cuenta del usuario' do
          post :create, user: attrs, format: 'json'
          expect(new_user).to be_nil
        end

        it 'devuelve un 400 bad request' do
          post :create, user: attrs, format: 'json'
          expect(response.response_code).to eq(400)
        end
      end
    end

    context 'cuando las contraseñas no coinciden' do
      let(:password)  { 'passEjem1' }
      let(:password_confirmation)  { 'passEjem1Distinta' }
      let(:new_user)  { User.find_by_email('amiguitos@test.com') }

      it 'no crea la cuenta del usuario' do
        post :create, user: attrs, format: 'json'
        expect(new_user).to be_nil
      end

      it 'devuelve un 400 bad request' do
        post :create, user: attrs, format: 'json'
        expect(response.response_code).to eq(400)
      end
    end
  end
end
