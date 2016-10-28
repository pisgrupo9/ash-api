require 'spec_helper'

describe Api::V1::AdoptersController do
  
  let(:user) { create(:user, account_active: 'true', permissions: 'adopters_edit') }
  let(:user2) { create(:user, account_active: 'true', permissions: 'default_user') }
  let(:user3) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let(:user4) { create(:user, account_active: 'true', permissions: 'super_user') }
  let(:adopter) { create(:adopter) }
  let(:adopter2) { create(:adopter) }

  let!(:params) do
    {
      ci: adopter2.ci,
      first_name:  adopter2.first_name,
      last_name:  adopter2.last_name,
      home_address:  adopter2.home_address,
      phone: adopter2.phone
    }
  end

  describe 'POST #create' do
    context 'exitoso' do 
      context 'por un usuario con permiso para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve codigo 201' do
          post :create, adopter: attributes_for(:adopter), format: 'json'
          expect(response.status).to eq(201)
        end

        it 'la cantidad de adoptantes aumenta' do
          expect { post :create, adopter: attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
        end

        it 'devuelve un adoptante no vacío' do
          post :create, adopter: attributes_for(:adopter), format: 'json'
          new_adopter = Adopter.last
          expect(new_adopter).to_not be_nil
        end
      end

      context 'por un usuario con permiso super usuario' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user4.authentication_token
        end

        it 'devuelve codigo 201' do
          post :create, adopter: attributes_for(:adopter), format: 'json'
          expect(response.status).to eq(201)
        end

        it 'la cantidad de adoptantes aumenta' do
          expect { post :create, adopter: attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
        end

        it 'devuelve un adoptante no vacío' do
          post :create, adopter: attributes_for(:adopter), format: 'json'
          new_adopter = Adopter.last
          expect(new_adopter).to_not be_nil
        end
      end
    end

    context 'no exitoso' do
      context 'con atributos ya existentes (cedula)' do
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

      context 'por un usuario con permiso de editar adoptantes' do
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
    end
  end

  describe 'PUT #update' do
    context 'exitoso' do
      
      let(:params1) { {first_name: Faker::Name.first_name} }
      let(:params2) { {last_name: Faker::Name.last_name} }
      let(:params3) { {home_address: Faker::Address.street_address} }
      let(:params4) { {blacklisted: Faker::Boolean.boolean} }
      let(:params5) { {phone: Faker::Number.number(9)} }
      let(:params6) { {house_description: Faker::Lorem.sentence} }

      context 'por usuario con permiso para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve el id del adoptante' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(parse_response(response)['id']).to eq(adopter.id)
        end

        it 'devuelve codigo 200' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(response.status).to eq(200)
        end

        it 'el nombre se cambia correctamente' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(adopter.reload.first_name).to eq(params1[:first_name])
        end

        it 'el apellido se cambia correctamente' do
          put :update, id: adopter.id, adopter: params2, format: 'json'
          expect(adopter.reload.last_name).to eq(params2[:last_name])
        end

        it 'la direccion se cambia correctamente' do
          put :update, id: adopter.id, adopter: params3, format: 'json'
          expect(adopter.reload.home_address).to eq(params3[:home_address])
        end

        it 'se cambia si esta o no en lista negra correctamente' do
          put :update, id: adopter.id, adopter: params4, format: 'json'
          expect(adopter.reload.blacklisted).to eq(params4[:blacklisted])
        end

        it 'el telefono se cambia correctamente' do
          put :update, id: adopter.id, adopter: params5, format: 'json'
          expect(adopter.reload.phone).to eq(params5[:phone])
        end

        it 'la descripcion de la casa se cambia correctamente' do
          put :update, id: adopter.id, adopter: params6, format: 'json'
          expect(adopter.reload.house_description).to eq(params6[:house_description])
        end
      end

      context 'por usuario con permiso super usuario' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user4.authentication_token
        end

        it 'devuelve el id del adoptante' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(parse_response(response)['id']).to eq(adopter.id)
        end

        it 'devuelve codigo 200' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(response.status).to eq(200)
        end

        it 'el nombre se cambia correctamente' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(adopter.reload.first_name).to eq(params1[:first_name])
        end

        it 'el apellido se cambia correctamente' do
          put :update, id: adopter.id, adopter: params2, format: 'json'
          expect(adopter.reload.last_name).to eq(params2[:last_name])
        end

        it 'la direccion se cambia correctamente' do
          put :update, id: adopter.id, adopter: params3, format: 'json'
          expect(adopter.reload.home_address).to eq(params3[:home_address])
        end

        it 'se cambia si esta o no en lista negra correctamente' do
          put :update, id: adopter.id, adopter: params4, format: 'json'
          expect(adopter.reload.blacklisted).to eq(params4[:blacklisted])
        end

        it 'el telefono se cambia correctamente' do
          put :update, id: adopter.id, adopter: params5, format: 'json'
          expect(adopter.reload.phone).to eq(params5[:phone])
        end

        it 'la descripcion de la casa se cambia correctamente' do
          put :update, id: adopter.id, adopter: params6, format: 'json'
          expect(adopter.reload.house_description).to eq(params6[:house_description])
        end      
      end
    end

    context 'no exitoso' do
      context 'de atributos del adoptante con usuarios con permisos' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params1) { {first_name: ''} }
        let(:params2) { {last_name: ''} }
        let(:params3) { {home_address: ''} }
        let(:params4) { {phone: ''} }
        let(:params5) { {ci: CiUY.random} }
        let(:params6) { {ci: ''} }
        let(:params7) { {phone: '  '} }
        let(:params8) { {first_name: ' '} }
        let(:params9) { {last_name: '   '} }

        it 'devuelve codigo 400' do
          put :update, id: adopter.id, adopter: params5, format: 'json'
          expect(response.status).to eq(400)
        end

        it 'la ci no cambia por otra' do
          put :update, id: adopter.id, adopter: params5, format: 'json'
          expect(adopter.reload.ci).to_not eq(params5[:ci])
        end

        it 'la ci no cambia por vacío' do
          put :update, id: adopter.id, adopter: params6, format: 'json'
          expect(adopter.reload.ci).to_not eq(params6[:ci])
        end

        it 'el nombre no cambia' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(adopter.reload.first_name).to_not eq(params1[:first_name])
        end

        it 'el apellido no cambia' do
          put :update, id: adopter.id, adopter: params2, format: 'json'
          expect(adopter.reload.last_name).to_not eq(params2[:last_name])
        end

        it 'la direccion no cambia' do
          put :update, id: adopter.id, adopter: params4, format: 'json'
          expect(adopter.reload.home_address).to_not eq(params4[:home_address])
        end

        it 'el telefono no cambia' do
          put :update, id: adopter.id, adopter: params4, format: 'json'
          expect(adopter.reload.phone).to_not eq(params4[:phone])
        end

        it 'el telefono no cambia por uno con espacios' do
          put :update, id: adopter.id, adopter: params7, format: 'json'
          expect(adopter.reload.phone).to_not eq(params7[:phone])
        end

        it 'el nombre no cambia por uno con espacios' do
          put :update, id: adopter.id, adopter: params8, format: 'json'
          expect(adopter.reload.first_name).to_not eq(params8[:first_name])
        end

        it 'el apellido no cambia por uno con espacios' do
          put :update, id: adopter.id, adopter: params9, format: 'json'
          expect(adopter.reload.last_name).to_not eq(params9[:last_name])
        end
      end

      context 'de atributos del adoptante con usuario sin permisos' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end

        let(:params1) { { first_name: Faker::Name.first_name } }
        let(:params2) { {phone: Faker::Number.number(9)} }

        it 'el nombre no cambia' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(adopter.reload.last_name).to_not eq(params1[:last_name])
        end

        it 'devuelve error' do
          put :update, id: adopter.id, adopter: params1, format: 'json'
          expect(parse_response(response)['error']).to eq('Faltan permisos')
        end

        it 'el telefono no cambia' do
          put :update, id: adopter.id, adopter: params2, format: 'json'
          expect(adopter.reload.phone).to_not eq(params2[:phone])
        end
      end
    end
  end

  describe 'GET #index' do
    context 'se listan los adoptantes del sistema' do
      
      let!(:adopter4) { create(:adopter) }
      let!(:adopter5) { create(:adopter) }

      context 'con un usuario con permisos para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve una array con los adoptantes' do
          get :index, format: 'json'
          expect(parse_response(response)['adopters']).to_not be_nil
        end

        it 'devuelve codigo 200' do
          get :index, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'con un usuario sin permisos para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end

        it 'devuelve una array con los adoptantes' do
          get :index, format: 'json'
          expect(parse_response(response)['adopters']).to_not be_nil
        end

        it 'devuelve codigo 200' do
          get :index, format: 'json'
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'de un adoptante' do
      context 'con un usuario con permisos para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve una array no vacio' do
          get :show, id: adopter.id, format: 'json'
          expect(parse_response(response)).to_not be_nil
        end

        it 'devuelve una array con los datos del adoptante creado' do
          get :show, id: adopter.id, format: 'json'
          expect(parse_response(response)['id']).to eq(adopter.id)
          expect(parse_response(response)['ci']).to eq(adopter.ci)
          expect(parse_response(response)['first_name']).to eq(adopter.first_name)
          expect(parse_response(response)['last_name']).to eq(adopter.last_name)
          expect(parse_response(response)['email']).to eq(adopter.email)
          expect(parse_response(response)['phone']).to eq(adopter.phone)
          expect(parse_response(response)['house_description']).to eq(adopter.house_description)
          expect(parse_response(response)['blacklisted']).to eq(adopter.blacklisted)
          expect(parse_response(response)['home_address']).to eq(adopter.home_address)
        end

        it 'devuelve codigo 200' do
          get :show, id: adopter.id, format: 'json'
          expect(response.status).to eq(200)
        end
      end

      context 'con un usuario sin permisos para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end

        it 'devuelve una array no vacio' do
          get :show, id: adopter2.id, format: 'json'
          expect(parse_response(response)).to_not be_nil
        end

        it 'devuelve una array con los datos del adoptante creado' do
          get :show, id: adopter.id, format: 'json'
          expect(parse_response(response)['id']).to eq(adopter.id)
          expect(parse_response(response)['ci']).to eq(adopter.ci)
          expect(parse_response(response)['first_name']).to eq(adopter.first_name)
          expect(parse_response(response)['last_name']).to eq(adopter.last_name)
          expect(parse_response(response)['email']).to eq(adopter.email)
          expect(parse_response(response)['phone']).to eq(adopter.phone)
          expect(parse_response(response)['house_description']).to eq(adopter.house_description)
          expect(parse_response(response)['blacklisted']).to eq(adopter.blacklisted)
          expect(parse_response(response)['home_address']).to eq(adopter.home_address)
        end

        it 'devuelve codigo 200' do
          get :show, id: adopter2.id, format: 'json'
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'GET #search' do
    context 'se listan los adoptantes buscados' do

      let!(:adToSearch) { create(:adopter, first_name: 'Miguel', last_name: 'Viera') }
      let!(:adToSearch2) { create(:adopter, first_name: 'Charly', last_name: 'Sosa', blacklisted: 'true') }
      let!(:adToSearch3) { create(:adopter, first_name: 'Char', last_name: 'Mate', blacklisted: 'true') }
      let!(:adToSearch4) { create(:adopter, first_name: 'Charly', last_name: 'Sosa', blacklisted: 'false') }

      before(:each) do
        request.headers['X-USER-TOKEN'] = user.authentication_token
      end

      context 'por nombre especifico' do
        it 'devuelve codigo 200' do
          get :search, name: 'Miguel', format: 'json'
          expect(response.status).to eq(200)
        end

        it 'devuelve un array no vacio' do
          get :search, name: 'Miguel', format: 'json'
          expect(parse_response(response)['adopters']).to_not be_nil
        end

        it 'devuelve el adoptante buscado' do
          get :search, name: 'Miguel', format: 'json'
          expect(parse_response(response)['adopters'][0]['id']).to eq(adToSearch.id)
        end
      end

      context 'por nombre parcial en lista negra' do
        it 'devuelve codigo 200' do
          get :search, name: 'Cha', blacklisted: 'true', format: 'json'
          expect(response.status).to eq(200)
        end

        it 'devuelve un array no vacio' do
          get :search, name: 'Cha', blacklisted: 'true', format: 'json'
          expect(parse_response(response)['adopters']).to_not be_nil
        end

        it 'devuelve los adoptantes encontrados' do
          get :search, name: 'Cha', blacklisted: 'true', format: 'json'
          @id1 = parse_response(response)['adopters'][0]['id']
          @id2 = parse_response(response)['adopters'][1]['id']
          @arrids = [@id1,@id2]
          expect(@arrids).to match_array([adToSearch2.id,adToSearch3.id])
        end
      end

      context 'por nombre especifico en lista negra' do
        it 'devuelve codigo 200' do
          get :search, name: 'Charly', blacklisted: 'true', format: 'json'
          expect(response.status).to eq(200)
        end

        it 'devuelve un array no vacio' do
          get :search, name: 'Charly', blacklisted: 'true', format: 'json'
          expect(parse_response(response)['adopters']).to_not be_nil
        end

        it 'devuelve el adoptante de la lista negra' do
          get :search, name: 'Charly', blacklisted: 'true', format: 'json'
          expect(parse_response(response)['adopters'][0]['id']).to eq(adToSearch2.id)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    
    let!(:adopter3) { create(:adopter) }

    context 'exitoso' do
      before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
      end

      it 'devuelve codigo 204 No Content' do
        delete :destroy, id: adopter3.id, format: 'json'
        expect(response.status).to eq(204)
      end

      it 'la cantidad de adoptantes cambia' do
        expect { delete :destroy, id: adopter3.id, format: 'json' }.to change { Adopter.count }
      end
    end

    context 'no exitoso' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user2.authentication_token
      end

      it 'la cantidad de adoptantes no cambia' do        
        expect { delete :destroy, id: adopter3.id, format: 'json' }.not_to change { Adopter.count }
      end

      it 'devuelve error' do
        delete :destroy, id: adopter3.id, format: 'json'
        expect(parse_response(response)['error']).to eq('Faltan permisos')
      end

      it 'devuelve no vacio' do
        delete :destroy, id: adopter3.id, format: 'json'
        adopter_aux = Adopter.find(adopter3.id)
        expect(adopter_aux).to_not be_nil
      end
    end
  end
end
