require 'spec_helper'
require 'json'

  describe Api::V1::SessionsController, type: :controller do
    before :each do
     @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'create' do
      let(:password) { 'password' }
      let(:first_name) { 'Peter' }
      let(:last_name) { 'Test' }
      let (:email) { 'example@example.com' }
      let!(:user) { create(:user, email: email, password: password,  first_name: first_name, last_name: last_name) }
      let(:phone) { user.phone }
      let(:account_active) { user.account_active }
      let(:params)   { { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone, account_active: account_active } }
      context 'with valid login' do
        it 'returns the user json' do
          post :create, user: params, format: 'json'
          expect(parse_response(response)['token']).to_not be_nil
        end
      end
    end
  end