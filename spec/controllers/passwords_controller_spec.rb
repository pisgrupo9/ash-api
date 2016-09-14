# encoding: utf-8

require 'spec_helper'

describe Api::V1::PasswordsController do
	let!(:user)	 { create(:user, password: 'password') }
	let(:password_token)	{ user.send(:set_reset_password_token) }
	let(:new_password)	{ 'nuevapassword' }

	before :each do
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    Delayed::Worker.delay_jobs = false
		@request.env['devise.mapping'] = Devise.mappings[:user]
	end

	context 'cambio de password' do

    it 'retorna operacion exitosa' do
      post :create, user: { email: user.email }, format: 'json'
      expect(response.status).to eq(204)
    end

		it 'envia un email' do
			expect { post :create, user: { email: user.email }, format: 'json' }
				.to change { ActionMailer::Base.deliveries.count }.by(1)
		end

		it 'retorna operacion exitosa' do
			put :update,
				user: {
					password: new_password,
					password_confirmation: new_password,
					reset_password_token: password_token
				},
				format: 'json'
			expect(response.status).to eq(204)
		end
  end

	context 'pasamos parametros incorrectos' do
		it 'retorna operacion fallida' do
			post :create, user: { email: 'mailDistinto@mail.com' }, format: 'json'
			expect(response.status).to eq(400)
		end

		it 'no se envia el mail' do
			expect { post :create, user: { email: 'mailDistinto@mail.com' }, format: 'json' }
				.to change { ActionMailer::Base.deliveries.count }.by(0)
		end

		it 'retorna operacion fallida porque la password_confirmation y la password no coinciden' do
			put :update,
				user: {
					password: new_password,
					password_confirmation: 'passwordDistinta',
					reset_password_token: password_token
				},
				format: 'json'
			expect(response.status).to eq(400)
		end

		it 'retorna operacion fallida porque el token de cambio de password es incorrecto' do
			put :update,
				user: {
					password: 'password123',
					password_confirmation: 'password123',
					reset_password_token: 'token_invalido'
				},
				format: 'json'
			expect(response.status).to eq(400)
		end
	end
end
