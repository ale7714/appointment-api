require 'spec_helper'

describe 'Appointments API' do

    describe 'List' do

        context "without parameters" do
                before do 
                    Fabricate(:appointment, start_time: "2014-05-21T10:30:00", end_time: "2014-05-21T11:30:00")
                    Fabricate(:appointment, start_time: "2014-05-21T12:30:00", end_time: "2014-05-21T13:30:00")
                    Fabricate(:appointment, start_time: "2014-05-21T14:00:00", end_time: "2014-05-21T14:30:00")
                    get '/api/v1/appointments', format: :json
                end

                it "returns all appointments" do
                    expect(json.count).to eq(3)
                end
                it "returns a 200 status" do
                    expect(response).to be_success
                    expect(response.status).to eq(200)
                end
        end

        context "with well formatted parameters" do
                before do 
                    Fabricate(:appointment, start_time: "2014-05-21T10:30:00", end_time: "2014-05-21T11:30:00")
                    Fabricate(:appointment, start_time: "2014-05-21T12:30:00", end_time: "2014-05-21T13:30:00")
                    Fabricate(:appointment, start_time: "2014-05-21T14:00:00", end_time: "2014-05-21T14:30:00")
                    get '/api/v1/appointments', {start_time: "2014-05-21T09:00:00", 
                                 end_time: "2014-05-21T14:00:00",
                                format: :json}
                end

                it "returns all appointments between start_time and end_time parameters" do
                    expect(json.count).to eq(2)
                end

                it "returns a 200 status" do
                    expect(response).to be_success
                    expect(response.status).to eq(200)
                end
        end

        context "with bad formatted parameters" do
                before do 
                    Fabricate(:appointment, start_time: "2014-05-21T10:30:00", end_time: "2014-05-21T11:30:00")
                    get '/api/v1/appointments', {start_time: "13/13/2014", format: :json}
                end

                it "returns a 400 status" do
                    expect(response).to_not be_success
                    expect(response.status).to eq(400)
                end
        end
    end

    describe 'Create' do

        context "sucessful" do

            before do 
                post '/api/v1/appointments', { appointment: {
                                                    first_name: "Mary", 
                                                    last_name: "Walls",
                                                    start_time: "2014-05-21T10:30:00",
                                                    end_time: "2014-05-21T11:30:00",
                                                    }, 
                                              format: :json}
                @appointment = Appointment.last
                @route = "/api/v1/appointments/#{@appointment.id}"
            end


            it "returns the appointment" do
                expect(json).to eq(JSON.parse(@appointment.to_json))
            end

            it "returns a 201 status" do
                expect(response.headers["Location"]).to eql(@route)
                expect(response).to be_success
                expect(response.status).to eq(201)
            end
        end
        
        context "unsuccessful" do
            before do 
                post '/api/v1/appointments', { appointment: {},
                                              format: :json}
            end

            it "returns the errors" do
                errors = { "errors" => { "first_name" => ["can't be blank"],
                                     "last_name" =>  ["can't be blank"],
                                     "start_time" => ["can't be blank"],
                                     "end_time" =>   ["can't be blank"]}}
                expect(json).to eq(errors)
            end

            it "returns a 422 status" do
                expect(response).to_not be_success
                expect(response.status).to eq(422)
            end
        end

    end

    describe 'Show' do

        context 'existing ID' do

            before do 
                @appointment =  Fabricate(:appointment, start_time: "2014-05-21T10:30:00", 
                                end_time: "2014-05-21T11:30:00")
                get "/api/v1/appointments/#{@appointment.id}", format: :json
            end

            it "returns the appointment" do
                expect(json).to eq(JSON.parse(@appointment.to_json))
            end

            it "returns a 200 status" do
                expect(response).to be_success
                expect(response.status).to eq(200)
            end
        end

        context 'non existing ID' do

            before do 
                get '/api/v1/appointments/5', format: :json
            end

            it "returns a 404 status" do
                expect(response).to_not be_success
                expect(response.status).to eq(404)
            end
        end

    end

    describe 'Update' do

        context "sucessful" do

            before do 
                @appointment =  Fabricate(:appointment, first_name: "Mary", 
                                                    last_name: "Walls", 
                                                    start_time: "2014-05-21T10:30:00",
                                                    end_time: "2014-05-21T11:30:00")
                put "/api/v1/appointments/#{@appointment.id}", { appointment: {  
                                                    start_time: "2014-05-21T11:00:00"
                                                    }, 
                                              format: :json}
            end


            it "returns the appointment" do
                @appointment.reload
                expect(@appointment.start_time.to_s).to include("2014-05-21 11:00:00")
            end

            it "returns a 204 status" do
                expect(response).to be_success
                expect(response.status).to eq(204)
            end
        end
        
        context "unsuccessful" do
            before do 
                Fabricate(:appointment, first_name: "Mary", last_name: "Walls", 
                            start_time: "2014-05-21T08:30:00", end_time: "2014-05-21T09:30:00")
                @appointment =  Fabricate(:appointment, first_name: "Mary", 
                                                    last_name: "Walls", 
                                                    start_time: "2014-05-21T10:30:00",
                                                    end_time: "2014-05-21T11:30:00")
                put "/api/v1/appointments/#{@appointment.id}", { appointment: {  
                                                    start_time: "2014-05-21T09:00:00"
                                                    }, 
                                              format: :json}
            end


            it "returns the erorrs" do
                errors = {"errors"=>{"end_time"=>["Time period can not overlap with existing appointments"], 
                                    "start_time"=>["Time period can not overlap with existing appointments"]}}
                expect(json).to eq(errors)
            end

            it "returns a 422 status" do
                expect(response).to_not be_success
                expect(response.status).to eq(422)
            end
        end

    end

    describe 'Delete' do

        before do 
            @appointment = Fabricate(:appointment)
            delete "/api/v1/appointments/#{@appointment.id}", { format: :json}
        end

        it "returns a 204 status" do
            expect(response).to be_success
            expect(response.status).to eq(204)
        end
    end

end