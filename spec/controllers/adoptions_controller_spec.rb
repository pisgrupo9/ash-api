require 'spec_helper'

describe Api::V1::AdoptionsController do
  
  let(:user) { create(:user, account_active: 'true', permissions: 'adopters_edit') }
  let(:user2) { create(:user, account_active: 'true', permissions: 'default_user') }
  let(:user3) { create(:user, account_active: 'true', permissions: 'animals_edit') }
  let(:user4) { create(:user, account_active: 'true', permissions: 'super_user') }

  let(:adopter) { create(:adopter) }
  let(:adopter2) { create(:adopter, blacklisted: 'true') }
  let(:adopter3) { create(:adopter) }
  let(:species) { create(:species, name: 'Perro', adoptable: 'true') }
  let(:species2) { create(:species, name: 'Gallina', adoptable: 'false') }
  let(:animal) { create(:animal, species_id: species.id, vaccines: 'true', castrated: 'true', type: 'Adoptable') }
  let(:animal1) { create(:animal, species_id: species.id, vaccines: 'false', castrated: 'true', type: 'Adoptable') }
  let(:animal2) { create(:animal, species_id: species.id, vaccines: 'true', castrated: 'false', type: 'Adoptable') }
  let(:animal3) { create(:animal, species_id: species2.id, vaccines: 'true', castrated: 'true') }

  let(:adoption) { create(:adoption, adopter_id: adopter3.id, animal_id: animal.id, date: '2016-11-01') }

  let!(:params) do
    {
      adopter_id: adopter.id,
      animal_id:  animal.id,
      date: '2016-11-01'
    }
  end

  describe 'POST #create' do
    context 'exitoso' do
      context 'por un usuario con permiso para editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        it 'devuelve codigo 201' do
          post :create, adoption: params, format: 'json'
          expect(response.status).to eq(201)
        end

        it 'la cantidad de adopciones aumenta' do
          expect { post :create, adoption: params, format: 'json' }.to change { Adoption.count }.by(+1)
        end

        it 'devuelve la ultima adopcion no vacía' do
          post :create, adoption: params, format: 'json'
          new_adoption = Adoption.last
          expect(new_adoption).to_not be_nil
        end

        it 'se verifica la adopcion creada' do
          post :create, adoption: params, format: 'json'
          new_adoption = Adoption.last
          expect(new_adoption.animal_id).to eq(params[:animal_id])
          expect(new_adoption.adopter_id).to eq(params[:adopter_id])
        end

        it 'se verifica que se actualice el animal' do
          post :create, adoption: params, format: 'json'
          expect(animal.reload.adopted).to eq(true)
        end

        it 'se verifica el evento creado' do
          post :create, adoption: params, format: 'json'
          new_event = Event.last
          expect(new_event.animal_id).to eq(params[:animal_id])
          expect(new_event.description).to eq("El animal fue adoptado por #{adopter.first_name} #{adopter.last_name}.")
          expect("#{new_event.date}").to eq(params[:date])
        end
      end

      context 'por un usuario con permiso super usuario' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user4.authentication_token
        end

        it 'devuelve codigo 201' do
          post :create, adoption: params, format: 'json'
          expect(response.status).to eq(201)
        end

        it 'la cantidad de adopciones aumenta' do
          expect { post :create, adoption: params, format: 'json' }.to change { Adoption.count }.by(+1)
        end

        it 'devuelve la ultima adopcion no vacía' do
          post :create, adoption: params, format: 'json'
          new_adoption = Adoption.last
          expect(new_adoption).to_not be_nil
        end

        it 'se verifica la ultima adopcion creada' do
          post :create, adoption: params, format: 'json'
          new_adoption = Adoption.last
          expect(new_adoption.animal_id).to eq(params[:animal_id])
          expect(new_adoption.adopter_id).to eq(params[:adopter_id])
          expect("#{new_adoption.date}").to eq(params[:date])
        end

        it 'se verifica que se actualice el animal' do
          post :create, adoption: params, format: 'json'
          expect(animal.reload.adopted).to eq(true)
        end

        it 'se verifica el evento creado' do
          post :create, adoption: params, format: 'json'
          new_event = Event.last
          expect(new_event.animal_id).to eq(params[:animal_id])
          expect(new_event.description).to eq("El animal fue adoptado por #{adopter.first_name} #{adopter.last_name}.")
          expect("#{new_event.date}").to eq(params[:date])
        end
      end
    end

    context 'no exitoso' do
      context 'por un usuario con permiso por defecto' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user2.authentication_token
        end

        it 'devuelve codigo 403' do
          post :create, adoption: params, format: 'json'
          expect(response.status).to eq(403)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params, format: 'json' }.not_to change { Adoption.count }
        end

        it 'devuelve mensaje de error' do
          post :create, adoption: params, format: 'json'
          expect(parse_response(response)['error']).to eq('Faltan permisos')
        end
      end

      context 'por un usuario con permiso de editar adoptantes' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user3.authentication_token
        end

        it 'devuelve codigo 403' do
          post :create, adoption: params, format: 'json'
          expect(response.status).to eq(403)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params, format: 'json' }.not_to change { Adoption.count }
        end

        it 'devuelve mensaje de error' do
          post :create, adoption: params, format: 'json'
          expect(parse_response(response)['error']).to eq('Faltan permisos')
        end
      end

      context 'con un adoptante en blacklist' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params) { { adopter_id: adopter2.id, animal_id: animal.id, date: '2016-11-01' } }

        it 'devuelve codigo 422' do
          post :create, adoption: params, format: 'json'
          expect(response.status).to eq(422)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params, format: 'json' }.not_to change { Adoption.count }
        end

        it 'devuelve mensaje de error' do
          post :create, adoption: params, format: 'json'
          expect(parse_response(response)['error']['adopter_id']).to eq(['El adoptante está en la lista negra.'])
        end
      end

      context 'con un animal sin vacunar' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params1) { { adopter_id: adopter.id, animal_id: animal1.id, date: '2016-11-01' } }

        it 'devuelve codigo 422' do
          post :create, adoption: params1, format: 'json'
          expect(response.status).to eq(422)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params1, format: 'json' }.not_to change { Adoption.count }
        end

        it 'devuelve error' do
          post :create, adoption: params1, format: 'json'
          expect(parse_response(response)['error']['animal_id']).to eq(['El animal no tiene las vacunas al día'])
        end
      end

      context 'con un animal sin castrar' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params2) { { adopter_id: adopter.id, animal_id: animal2.id, date: '2016-11-01' } }

        it 'devuelve codigo 422' do
          post :create, adoption: params2, format: 'json'
          expect(response.status).to eq(422)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params2, format: 'json' }.not_to change { Adoption.count }
        end

         it 'devuelve error' do
          post :create, adoption: params2, format: 'json'
          expect(parse_response(response)['error']['animal_id']).to eq(['El animal no está castrado'])
        end
      end

      context 'con un animal no adoptable' do
        before(:each) do
          request.headers['X-USER-TOKEN'] = user.authentication_token
        end

        let(:params3) { { adopter_id: adopter.id, animal_id: animal3.id, date: '2016-11-01' } }

        it 'devuelve codigo 422' do
          post :create, adoption: params3, format: 'json'
          expect(response.status).to eq(422)
        end

        it 'la cantidad de adopciones no aumenta' do
          expect { post :create, adoption: params3, format: 'json' }.not_to change { Adoption.count }
        end

        it 'devuelve error' do
          post :create, adoption: params3, format: 'json'
          expect(parse_response(response)['error']['animal_id']).to eq(['La especie del animal no es adoptable.'])
        end
      end
    end
  end

  describe 'GET #show' do
    context 'con un usuario con permisos' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user.authentication_token
        get :show, id: adoption.id, format: 'json'
      end

      it 'devuelve codigo 200' do
        expect(response.status).to eq(200)
      end

      it 'devuelve una array no vacio' do
        expect(parse_response(response)).to_not be_nil
      end

      it 'devuelve una array con los datos de la adopcion creada' do
        expect(parse_response(response)['animal_id']).to eq(adoption.animal_id)
        expect(parse_response(response)['adopter_id']).to eq(adoption.adopter_id)
        expect(parse_response(response)['date']).to eq("#{adoption.date}")
      end
    end

    context 'con un usuario sin permisos' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user2.authentication_token
        get :show, id: adoption.id, format: 'json'
      end

      it 'devuelve codigo 200' do
        expect(response.status).to eq(200)
      end

      it 'devuelve una array no vacio' do
        expect(parse_response(response)).to_not be_nil
      end

      it 'devuelve una array con los datos de la adopcion creada' do
        expect(parse_response(response)['animal_id']).to eq(adoption.animal_id)
        expect(parse_response(response)['adopter_id']).to eq(adoption.adopter_id)
        expect(parse_response(response)['date']).to eq("#{adoption.date}")
      end
    end
  end

  describe 'DELETE #destroy' do

    let!(:adoption) { create(:adoption, adopter_id: adopter.id, animal_id: animal.id, date: '2016-11-01') }

    context 'exitoso' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user.authentication_token
      end

      it 'devuelve codigo 204' do
        delete :destroy, id: adoption.id, format: 'json'
        expect(response.status).to eq(204)
      end

      it 'la cantidad de adopciones disminuye' do
        expect { delete :destroy, id: adoption.id, format: 'json' }.to change { Adoption.count }.by(-1)
      end
    end

    context 'no exitoso' do
      before(:each) do
        request.headers['X-USER-TOKEN'] = user2.authentication_token
      end

      it 'devuelve codigo 403' do
        delete :destroy, id: adoption.id, format: 'json'
        expect(response.status).to eq(403)
      end

      it 'la cantidad de adopciones no cambia' do
        expect { delete :destroy, id: adoption.id, format: 'json'}.not_to change { Adoption.count }
      end

      it 'devuelve no vacio' do
        delete :destroy, id: adoption.id, format: 'json'
        adoption_aux = Adoption.find(adoption.id)
        expect(adoption_aux).to_not be_nil
      end

      it 'devuelve la adopcion' do
        delete :destroy, id: adoption.id, format: 'json'
        adoption_aux = Adoption.find(adoption.id)
        expect(adoption_aux.animal_id).to eq(adoption.animal_id)
        expect(adoption_aux.adopter_id).to eq(adoption.adopter_id)
        expect(adoption_aux.date).to eq(adoption.date)
      end
    end
  end
end
