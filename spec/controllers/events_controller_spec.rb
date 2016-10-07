require 'spec_helper'

describe Api::V1::EventsController do

  let!(:user) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let!(:user_default) { create(:user, account_active: 'true', permissions: 'default_user') }
  let!(:event) { create(:events) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
    sign_in user_default
  end

  let(:params) do  
    { 
      name: event.name, 
      description: event.description, 
      date: event.date,
    } 
  end

  describe 'POST #create' do

    context 'de un evento' do
      context 'exitoso' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

      	it 'devuelve un estado 201 CREATED' do
         	post :create, { animal_id: event.animal.id, event: params }, format: 'json'
         	expect(response.status).to eq(201)
        end

        it 'la cantidad de eventos cambió' do
          expect { post :create, { animal_id: event.animal.id, event: params }, format: 'json' }.to change { Event.count }
        end

        it 'devuelve un animal no vacío' do
          post :create, { animal_id: event.animal.id, event: params }, format: 'json'
          nuevo_evento = Event.find(event.id)
          expect(nuevo_evento).to_not be_nil
        end
      end

      context 'no exitoso' do
      	context 'de usuario sin permiso de aniamles' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user_default.authentication_token
          end

          it 'la cantidad de eventos no cambió' do
            expect { post :create, { animal_id: event.animal.id, event: params }, format: 'json' }.not_to change { Event.count }
          end

          it 'devuelve un error' do
            post :create, { animal_id: event.animal.id, event: params }, format: 'json'
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end

  describe "GET #index" do

    context 'listado de los eventos de un animal' do
      context 'de un usuario con permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end
      
        it 'devuelve una array con los eventos' do
          get :index, { animal_id: event.animal.id, format: 'json' }
          expect(parse_response(response)['events']).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :index, { animal_id: event.animal.id, format: 'json' }
          expect(response.status).to eq(200)
        end
      end

      context 'de un usuario sin permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user_default.authentication_token
        end
      
        it 'devuelve una array con los eventos' do
          get :index, { animal_id: event.animal.id, format: 'json' }
          expect(parse_response(response)['events']).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :index, { animal_id: event.animal.id, format: 'json' } 
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "GET #show" do

    context 'del evento de un animal' do
      context 'de un usuario con permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end
      
        it 'devuelve una array de los campos de un evento' do
        	get :show, { animal_id: event.animal.id, id: event.id, format: 'json' }
        	expect(parse_response(response)).to_not be_nil
        end

        it 'devuelve un estado 200 OK' do
          get :show, { animal_id: event.animal.id, id: event.id, format: 'json' }
          expect(response.status).to eq(200)
        end

        it 'devuelve los campos del animal dentro del array' do
          get :show, { animal_id: event.animal.id, id: event.id, format: 'json' }
          expect(parse_response(response)['id']).to eq(event.id)
          expect(parse_response(response)['name']).to eq(event.name)
          expect(parse_response(response)['description']).to eq(event.description)
          expect(parse_response(response)['date']).to eq(event.date.to_formatted_s(:iso8601))
        end
      end

      context 'de un usuario sin permiso para animales' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user_default.authentication_token
        end
      
        it 'devuelve una array de los campos de un evento' do 
          get :show, { animal_id: event.animal.id, id: event.id, format: 'json' }
          expect(parse_response(response)['id']).to_not be_nil
        end

        it 'devuelve los campos del animal dentro del array' do 
          get :show, { animal_id: event.animal.id, id: event.id, format: 'json' }
          expect(parse_response(response)['id']).to eq(event.id)
          expect(parse_response(response)['name']).to eq(event.name)
          expect(parse_response(response)['description']).to eq(event.description)
          expect(parse_response(response)['date']).to eq(event.date.to_formatted_s(:iso8601))
        end

        it 'devuelve un estado 200 OK' do
          get :show, { animal_id: event.animal.id, id: event.id, format: 'json' } 
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "DELETE #destroy" do

    context 'de un evento' do
      context 'exitoso' do

        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve un 204 No Content' do
          delete :destroy, { animal_id: event.animal.id, id: event.id, format: 'json' }
          expect(response.status).to eq(204)
        end

        it 'la cantidad de eventos cambio' do
          expect { delete :destroy, animal_id: event.animal.id, id: event.id, format: 'json' }.to change { Event.count }
        end
      end

      context 'no exitoso' do
        context 'por un usuario que no tiene permiso de animales' do

          before(:each) do
            request.headers['X-USER-TOKEN'] = user_default.authentication_token
          end

          it 'la cantidad de eventos se mantiene igual' do
            expect { delete :destroy, animal_id: event.animal.id, id: event.id, format: 'json' }.not_to change { Event.count }
          end

          it 'devuelve un error' do
            delete :destroy, { animal_id: event.animal.id, id: event.id, format: 'json' }
            expect(parse_response(response)['error']).to eq('Faltan permisos')
          end
        end
      end
    end
  end
end
