require 'spec_helper'

describe Api::V1::AdoptersController do
  
  let!(:user) { create(:user, account_active: 'true', permissions: 'adopters_edit') }
  let!(:user2) { create(:user, account_active: 'true', permissions: 'default_user') }
  let!(:user3) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let!(:user4) { create(:user, account_active: 'true', permissions: 'super_user') }
  let(:adopter) { FactoryGirl.create(:adopter) }
  let!(:adopter2) { create(:adopter) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  let(:ci)  { adopter2.ci }
  let!(:params) do
    {
      ci: ci,
      first_name:  adopter2.first_name,
      last_name:  adopter2.last_name,
      home_address:  adopter2.home_address,
      phone: adopter2.phone
    }
  end

  describe 'POST #create' do
    context 'de un adoptante exitoso' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user.authentication_token
      end

      it 'devuelve codigo 201' do
        post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
        expect(response.status).to eq(201)
      end

      it 'la cantidad de adoptantes aumenta' do
        expect { post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
      end

      it 'devuelve un animal no vacío' do
        post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
        new_adopter = Adopter.find(adopter.id)
        expect(new_adopter).to_not be_nil
      end
    end

    context 'de un adoptante no exitoso' do
      context 'con chip repetido' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve codigo 422' do
          post :create, adopter: params, format: 'json'
          expect(response.status).to eq(422)
        end

        it 'la cantidad de adoptantes no aumenta' do
          expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
        end
      end
    end

    context 'por un usuario con permiso por defecto' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user2.authentication_token
      end

      it 'devuelve codigo 403' do
        post :create, adopter: params, format: 'json'
        expect(response.status).to eq(403)
      end

      it 'la cantidad de adoptantes no aumenta' do
        expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
      end

      it 'devuelve error' do
        post :create, adopter: params, format: 'json'
        expect(parse_response(response)['error']).to eq('Faltan permisos')
      end
    end

    context 'por un usuario con permiso de editar animales' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user3.authentication_token
      end

      it 'devuelve codigo 403' do
        post :create, adopter: params, format: 'json'
        expect(response.status).to eq(403)
      end

      it 'la cantidad de adoptantes no aumenta' do
        expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
      end

      it 'devuelve error' do
        post :create, adopter: params, format: 'json'
        expect(parse_response(response)['error']).to eq('Faltan permisos')
      end
    end

    context 'por un usuario con permiso super_user' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user4.authentication_token
      end

      it 'devuelve codigo 201' do
        post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
        expect(response.status).to eq(201)
      end

      it 'la cantidad de adoptantes aumenta' do
        expect { post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
      end

      it 'devuelve un animal no vacío' do
        post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
        new_adopter = Adopter.find(adopter.id)
        expect(new_adopter).to_not be_nil
      end
    end
  end
end
