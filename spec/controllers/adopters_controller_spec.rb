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

  # describe 'POST #create' do
  #   context 'exitoso' do 
  #     context 'por un usuario con permiso para editar adoptantes' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user.authentication_token
  #       end

  #       it 'devuelve codigo 201' do
  #         post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
  #         expect(response.status).to eq(201)
  #       end

  #       it 'la cantidad de adoptantes aumenta' do
  #         expect { post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
  #       end

  #       it 'devuelve un adoptante no vacío' do
  #         post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
  #         new_adopter = Adopter.find(adopter.id)
  #         expect(new_adopter).to_not be_nil
  #       end
  #     end

  #     context 'por un usuario con permiso super usuario' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user4.authentication_token
  #       end

  #       it 'devuelve codigo 201' do
  #         post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
  #         expect(response.status).to eq(201)
  #       end

  #       it 'la cantidad de adoptantes aumenta' do
  #         expect { post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json' }.to change { Adopter.count }
  #       end

  #       it 'devuelve un adoptante no vacío' do
  #         post :create, adopter: FactoryGirl.attributes_for(:adopter), format: 'json'
  #         new_adopter = Adopter.find(adopter.id)
  #         expect(new_adopter).to_not be_nil
  #       end
  #     end
  #   end

  #   context 'no exitoso' do
  #     context 'con chip repetido' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user.authentication_token
  #       end

  #       it 'devuelve codigo 422' do
  #         post :create, adopter: params, format: 'json'
  #         expect(response.status).to eq(422)
  #       end

  #       it 'la cantidad de adoptantes no aumenta' do
  #         expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
  #       end
  #     end

  #     context 'por un usuario con permiso por defecto' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user2.authentication_token
  #       end

  #       it 'devuelve codigo 403' do
  #         post :create, adopter: params, format: 'json'
  #         expect(response.status).to eq(403)
  #       end

  #       it 'la cantidad de adoptantes no aumenta' do
  #         expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
  #       end

  #       it 'devuelve error' do
  #         post :create, adopter: params, format: 'json'
  #         expect(parse_response(response)['error']).to eq('Faltan permisos')
  #       end
  #     end

  #     context 'por un usuario con permiso de editar adoptantes' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user3.authentication_token
  #       end

  #       it 'devuelve codigo 403' do
  #         post :create, adopter: params, format: 'json'
  #         expect(response.status).to eq(403)
  #       end

  #       it 'la cantidad de adoptantes no aumenta' do
  #         expect { post :create, adopter: params, format: 'json' }.not_to change { Adopter.count }
  #       end

  #       it 'devuelve error' do
  #         post :create, adopter: params, format: 'json'
  #         expect(parse_response(response)['error']).to eq('Faltan permisos')
  #       end
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context 'exitoso' do
      
  #     let(:params1) { {first_name: Faker::Name.first_name} }
  #     let(:params2) { {last_name: Faker::Name.last_name} }
  #     let(:params3) { {home_address: Faker::Address.street_address} }
  #     let(:params4) { {blacklisted: Faker::Boolean.boolean} }
  #     let(:params5) { {phone: Faker::Number.number(9)} }
  #     let(:params6) { {house_description: Faker::Lorem.sentence} }

  #     context 'por usuario con permiso para editar adoptantes' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user.authentication_token
  #       end

        
      
  #       it 'devuelve el id del adoptante' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(parse_response(response)['id']).to eq(adopter.id)
  #       end

  #       it 'devuelve codigo 200' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(response.status).to eq(200)
  #       end

  #       it 'el nombre se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(adopter.reload.first_name).to eq(params1[:first_name])
  #       end

  #       it 'el apellido se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params2, format: 'json'
  #         expect(adopter.reload.last_name).to eq(params2[:last_name])
  #       end

  #       it 'la direccion se cambia correctamente' do
  #    adopter     put :update, id: adopter.id, adopter: params3, format: 'json'
  #         expect(adopter.reload.home_address).to eq(params3[:home_address])
  #       end

  #       it 'se cambia si esta o no en lista negra correctamente' do
  #         put :update, id: adopter.id, adopter: params4, format: 'json'
  #         expect(adopter.reload.blacklisted).to eq(params4[:blacklisted])
  #       end

  #       it 'el telefono se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params5, format: 'json'
  #         expect(adopter.reload.phone).to eq(params5[:phone])
  #       end

  #       it 'la descripcion de la casa se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params6, format: 'json'
  #         expect(adopter.reload.house_description).to eq(params6[:house_description])
  #       end
  #     end

  #     context 'por usuario con permiso super usuario' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user4.authentication_token
  #       end

  #       it 'devuelve el id del adoptante' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(parse_response(response)['id']).to eq(adopter.id)
  #       end

  #       it 'devuelve codigo 200' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(response.status).to eq(200)
  #       end

  #       it 'el nombre se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(adopter.reload.first_name).to eq(params1[:first_name])
  #       end

  #       it 'el apellido se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params2, format: 'json'
  #         expect(adopter.reload.last_name).to eq(params2[:last_name])
  #       end

  #       it 'la direccion se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params3, format: 'json'
  #         expect(adopter.reload.home_address).to eq(params3[:home_address])
  #       end

  #       it 'se cambia si esta o no en lista negra correctamente' do
  #         put :update, id: adopter.id, adopter: params4, format: 'json'
  #         expect(adopter.reload.blacklisted).to eq(params4[:blacklisted])
  #       end

  #       it 'el telefono se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params5, format: 'json'
  #         expect(adopter.reload.phone).to eq(params5[:phone])
  #       end

  #       it 'la descripcion de la casa se cambia correctamente' do
  #         put :update, id: adopter.id, adopter: params6, format: 'json'
  #         expect(adopter.reload.house_description).to eq(params6[:house_description])
  #       end      
  #     end
  #   end

  #   context 'no exitoso' do
  #     context 'de atributos del adoptante con usuarios con permisos' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user.authentication_token
  #       end

  #       let(:params1) { {first_name: ''} }
  #       let(:params2) { {last_name: ''} }
  #       let(:params3) { {home_address: ''} }
  #       let(:params4) { {phone: ''} }
  #       let(:params5) { {ci: CiUY.random} }
  #       let(:params6) { {ci: ''} }
  #       let(:params7) { {phone: '  '} }
  #       let(:params8) { {first_name: ' '} }
  #       let(:params9) { {last_name: '   '} }

  #       it 'devuelve codigo 400' do
  #         put :update, id: adopter.id, adopter: params5, format: 'json'
  #         expect(response.status).to eq(400)
  #       end

  #       it 'la ci no cambia por otra' do
  #         put :update, id: adopter.id, adopter: params5, format: 'json'
  #         expect(adopter.reload.ci).to_not eq(params5[:ci])
  #       end

  #       it 'la ci no cambia por vacío' do
  #         put :update, id: adopter.id, adopter: params6, format: 'json'
  #         expect(adopter.reload.ci).to_not eq(params6[:ci])
  #       end

  #       it 'el nombre no cambia' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(adopter.reload.first_name).to_not eq(params1[:first_name])
  #       end

  #       it 'el apellido no cambia' do
  #         put :update, id: adopter.id, adopter: params2, format: 'json'
  #         expect(adopter.reload.last_name).to_not eq(params2[:last_name])
  #       end

  #       it 'la direccion no cambia' do
  #         put :update, id: adopter.id, adopter: params4, format: 'json'
  #         expect(adopter.reload.home_address).to_not eq(params4[:home_address])
  #       end

  #       it 'el telefono no cambia' do
  #         put :update, id: adopter.id, adopter: params4, format: 'json'
  #         expect(adopter.reload.phone).to_not eq(params4[:phone])
  #       end

  #       it 'el telefono no cambia por uno con espacios' do
  #         put :update, id: adopter.id, adopter: params7, format: 'json'
  #         expect(adopter.reload.phone).to_not eq(params7[:phone])
  #       end

  #       it 'el nombre no cambia por uno con espacios' do
  #         put :update, id: adopter.id, adopter: params8, format: 'json'
  #         expect(adopter.reload.first_name).to_not eq(params8[:first_name])
  #       end

  #       it 'el apellido no cambia por uno con espacios' do
  #         put :update, id: adopter.id, adopter: params9, format: 'json'
  #         expect(adopter.reload.last_name).to_not eq(params9[:last_name])
  #       end
  #     end

  #     context 'de atributos del adoptante con usuario sin permisos' do
  #       before(:each) do
  #         request.headers['X-USER-TOKEN'] = user2.authentication_token
  #       end

  #       let(:params1) { { first_name: Faker::Name.first_name } }
  #       let(:params2) { {phone: Faker::Number.number(9)} }

  #       it 'el nombre no cambia' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(adopter.reload.last_name).to_not eq(params1[:last_name])
  #       end

  #       it 'devuelve error' do
  #         put :update, id: adopter.id, adopter: params1, format: 'json'
  #         expect(parse_response(response)['error']).to eq('Faltan permisos')
  #       end

  #       it 'el telefono no cambia' do
  #         put :update, id: adopter.id, adopter: params2, format: 'json'
  #         expect(adopter.reload.phone).to_not eq(params2[:phone])
  #       end
  #     end
  #   end
  # end

  describe "DELETE #destroy" do
    
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
