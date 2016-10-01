require 'spec_helper'

describe Api::V1::AnimalsController do
  let!(:user) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let!(:user2) { create(:user, account_active: 'true', permissions: 'default_user') }
  let!(:animal) { create(:animal) }
   
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
    sign_in user2
  end

  describe 'POST #create' do

    let(:chip_num) { Faker::Code.isbn }

    let(:params) do  
      { 
        name: animal.name, 
        chip_num: chip_num, 
        race: animal.race, 
        sex: animal.sex, 
        vaccines: animal.vaccines, 
        castrated: animal.castrated, 
        admission_date: animal.admission_date, 
        birthdate: animal.birthdate, 
        species_id: animal.species_id 
      } 
    end
      
    context 'de un animal' do
      context 'exitoso' do

        it 'devuelve código 201 create' do
         	request.headers['X-USER-TOKEN'] = user.authentication_token
         	post :create, animal: params, format: 'json'
         	expect(response.status).to eq(201)
        end

        it 'la cantidad de animales aumento' do
          request.headers['X-USER-TOKEN'] = user.authentication_token
          expect { post :create, animal: params, format: 'json' }.to change { Animal.count }
        end

        it 'devuelve un animal no vacío' do
          request.headers['X-USER-TOKEN'] = user.authentication_token
          post :create, animal: FactoryGirl.attributes_for(:animal), format: 'json'
          new_animal = Animal.find(animal.id)
          expect(new_animal).to_not be_nil
        end
      end
        
      context 'no exitoso' do
        context 'con chip repetido' do
        
          let(:chip_num)  { animal.chip_num }

          it 'devuelve un estado 422' do
            request.headers['X-USER-TOKEN'] = user.authentication_token
            post :create, animal: params, format: 'json'
            expect(response.status).to eq(422)
          end

          it 'la cantidad de animales se mantiene igual' do
            request.headers['X-USER-TOKEN'] = user.authentication_token
            expect { post :create, animal: params, format: 'json' }.not_to change { Animal.count }
          end
        end

        context 'por un usuario que no tiene permiso de animales' do

          it 'devuelve un estado 403 Forbidden' do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
            post :create, animal: params, format: 'json'
            expect(response.status).to eq(403)
          end

          it 'la cantidad de animales se mantiene igual' do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
            expect { post :create, animal: params, format: 'json' }.not_to change { Animal.count }
          end

          it 'devuelve un error' do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
            post :create, animal: params, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end

  describe "GET #index" do

    context 'listado de los animales del sistema' do
      
      it 'devuelve una array con los animales' do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        get :index, format: 'json'
        expect(parse_response(response)['animals']).to_not be_nil
      end

      it 'devuelve un estado 200 OK' do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        get :index, format: 'json'
        expect(response.status).to eq(200)
      end
    end
  end

  describe "DELETE #destroy" do

    context 'de un animal' do
      context 'exitoso' do

        it 'devuelve un 204 No Content' do
          request.headers['X-USER-TOKEN'] = user.authentication_token
          delete :destroy, id: animal.id, format: 'json'
          expect(response.status).to eq(204)
        end

        it 'la cantidad de animales cambio' do
          request.headers['X-USER-TOKEN'] = user.authentication_token
          expect { delete :destroy, id: animal.id, format: 'json' }.to change { Animal.count }
        end
      end

      context 'no exitoso' do
        context 'por un usuario que no tiene permiso de animales' do

          it 'la cantidad de animales se mantiene igual' do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
            expect { delete :destroy, id: animal.id, format: 'json' }.not_to change { Animal.count }
          end

          it 'devuelve un error' do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
            delete :destroy, id: animal.id, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end
end
