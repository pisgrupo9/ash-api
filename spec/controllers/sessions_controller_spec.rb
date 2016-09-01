# encoding: utf-8

require 'spec_helper'

describe Api::V1::SessionsController do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:password) { 'mypass123' }    
    let!(:user)    { create(:user, password: password) }
    let(:email)    { user.email }
    let(:params)   { { email: email, password: password} }

    context 'with valid login' do
      it 'returns the user json' do
        post :create, user: params, format: 'json'       
        expect(parse_response(response)['token']).to_not be_nil
      end
    end
  end
end