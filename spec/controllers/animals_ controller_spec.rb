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

  let(:name) { animal.name }
  let(:chip_num) { Faker::Code.isbn }
  let(:birthdate)  { animal.birthdate }
  let(:admission_date) { animal.admission_date }

  let(:params) do  
    { 
      name: name, 
      chip_num: chip_num, 
      race: animal.race, 
      sex: animal.sex, 
      vaccines: animal.vaccines, 
      castrated: animal.castrated, 
      admission_date: admission_date, 
      birthdate: birthdate, 
      species_id: animal.species_id,
      profile_image: animal.profile_image,
      weight: animal.weight
    } 
  end

  describe 'POST #create' do

    context 'de un animal' do
      context 'exitoso' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve código 201 create' do
         	post :create, animal: params, format: 'json'
         	expect(response.status).to eq(201)
        end

        it 'la cantidad de animales aumento' do
          expect { post :create, animal: params, format: 'json' }.to change { Animal.count }
        end

        it 'devuelve un animal no vacío' do
          post :create, animal: FactoryGirl.attributes_for(:animal), format: 'json'
          new_animal = Animal.find(animal.id)
          expect(new_animal).to_not be_nil
        end
      end
        
      context 'no exitoso' do
        context 'con chip repetido' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user.authentication_token
          end
        
          let(:chip_num)  { animal.chip_num }

          it 'devuelve un estado 422' do
            post :create, animal: params, format: 'json'
            expect(response.status).to eq(422)
          end

          it 'la cantidad de animales se mantiene igual' do
            expect { post :create, animal: params, format: 'json' }.not_to change { Animal.count }
          end
        end

        context 'con la fecha de nacimiento posterior a la fecha de ingreso' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user.authentication_token
          end
        
          let(:birthdate)  { Faker::Date.between(3.days.ago, Date.today) }
          let(:admission_date) { Faker::Date.between(1.year.ago, 4.days.ago) }

          it 'devuelve un estado 422' do
            post :create, animal: params, format: 'json'
            expect(response.status).to eq(422)
          end

          it 'la cantidad de animales se mantiene igual' do
            expect { post :create, animal: params, format: 'json' }.not_to change { Animal.count }
          end
        end

        context 'por un usuario que no tiene permiso de animales' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
          end

          it 'devuelve un estado 403 Forbidden' do
            post :create, animal: params, format: 'json'
            expect(response.status).to eq(403)
          end

          it 'la cantidad de animales se mantiene igual' do
            expect { post :create, animal: params, format: 'json' }.not_to change { Animal.count }
          end

          it 'devuelve un error' do
            post :create, animal: params, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end

  describe "GET #index" do

    context 'listado de los animales del sistema' do
      context 'de un usuario con permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end
      
        it 'devuelve una array con los animales' do
          get :index, format: 'json'
          expect(parse_response(response)['animals']).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :index, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'de un usuario sin permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end
      
        it 'devuelve una array con los animales' do
          get :index, format: 'json'
          expect(parse_response(response)['animals']).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :index, format: 'json'
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "GET #show" do

    context 'del perfil de un animal' do
      context 'de un usuario con permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end
      
        it 'devuelve una array de los campos del animal' do
          get :show, id: animal.id, format: 'json'
          expect(parse_response(response)).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :show, id: animal.id, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'de un usuario sin permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end
      
        it 'devuelve una array de los campos del animales' do
          get :show, id: animal.id, format: 'json'
          expect(parse_response(response)).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :show, id: animal.id, format: 'json'
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "PUT #update" do

    context 'de un animal' do
      context 'exitoso de un usuario con permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params) { { name: 'nuevo_nombre' } }
      
        it 'devuelve el mismo id del animal' do
          put :update, id: animal.id, animal: params, format: 'json'
          expect(parse_response(response)['id']).to eq(animal.id)
        end

        it 'devuelve un estado 200 OK' do
          put :update, id: animal.id, animal: params, format: 'json'
          expect(response.status).to eq(200)
        end

        it 'compara que el nombre cambió' do
          put :update, id: animal.id, animal: params, format: 'json'
          expect(animal.reload.name).to eq('nuevo_nombre')
        end
      end

      context 'no exitoso' do
        context 'con el nombre en blanco' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user.authentication_token
          end

          let(:paramsUpdate) { { name: '' } }
      
          it 'devuelve un error' do
            put :update, id: animal.id, animal: paramsUpdate, format: 'json'
            expect(parse_response(response)['error']['name'][0]).to eq('no puede estar en blanco')
          end

          it 'devuelve un estado 400 BAD REQUEST' do
            put :update, id: animal.id, animal: paramsUpdate, format: 'json'
            expect(response.status).to eq(400)
          end

          it 'comprueba que el nombre no es vacío' do
            put :update, id: animal.id, animal: paramsUpdate, format: 'json'
            expect(animal.name).to_not be_nil
          end
        end

        context 'de un usuario sin permiso para animales' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
          end

          let(:paramsUpdate) { { name: 'nuevo_nombre' } }
      
          it 'comprueba que el nombre no cambió' do
            var_name = animal.name
            put :update, id: animal.id, animal: paramsUpdate, format: 'json'
            expect(animal.reload.name).to eq(var_name)
          end

          it 'devuelve un error' do
            put :update, id: animal.id, animal: paramsUpdate, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do

    context 'de un animal' do
      context 'exitoso' do

        before(:each) do
            request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve un 204 No Content' do
          delete :destroy, id: animal.id, format: 'json'
          expect(response.status).to eq(204)
        end

        it 'la cantidad de animales cambio' do
          expect { delete :destroy, id: animal.id, format: 'json' }.to change { Animal.count }
        end
      end

      context 'no exitoso' do
        context 'por un usuario que no tiene permiso de animales' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user2.authentication_token
          end

          it 'la cantidad de animales se mantiene igual' do            
            expect { delete :destroy, id: animal.id, format: 'json' }.not_to change { Animal.count }
          end

          it 'devuelve un error' do
            delete :destroy, id: animal.id, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end
end
