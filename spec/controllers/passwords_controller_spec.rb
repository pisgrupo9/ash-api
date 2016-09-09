# encoding: utf-8

require 'spec_helper'

describe Api::V1::PasswordsController do
	let!(:user)          { create(:user, password: 'password') }
  	let(:password_token) { user.send(:set_reset_password_token) }

  	before :each do
  		ActionMailer::Base.delivery_method = :test
	    ActionMailer::Base.perform_deliveries = true
	    ActionMailer::Base.deliveries = []
	    Delayed::Worker.delay_jobs = false
		@request.env['devise.mapping'] = Devise.mappings[:user]
	end

	describe 'POST #create' do
		context 'una nueva password' do	      
        	let(:new_password) { 'nuevapassword' }

		    it 'se ha enviado el email con exito' do
		      post :create, user: { email: user.email }, format: 'json'
		      expect(response.status).to be(204)
		    end
        end   
	end
end
