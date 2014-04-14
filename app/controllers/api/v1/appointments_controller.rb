module Api
    module V1
        class AppointmentsController < ApplicationController
            skip_before_action :verify_authenticity_token
            
            respond_to :json

            before_action :build_list_filter, only: [:index]
            before_action :find_appointment, only: [:show, :update, :destroy]

            ##
            # Returns a list of appointments 
            #
            # GET /api/v1/appointments
            #
            # params:
            #   start_time - [optional] +DateTime+ To filter by start time
            #   end_time  -  [optional] +DateTime+To filter by start time
            #
            # = Examples (using cURL)
            #
            #   curl --request GET http://localhost:3000/api/v1/appointments
            #
            #   resp.status
            #   => 200
            #
            #   resp.body
            #   => [{"id":1,"first_name":"ale","last_name":"paredes","comment":"","start_time":"2014-04-12T22:03:00.000Z",
            #        "end_time":"2014-04-12T23:03:00.000Z","created_at":"2014-04-12T21:05:00.000Z","updated_at":"2014-04-12T21:05:00.000Z"}]
            #   
            #   curl --request GET http://localhost:3000/api/v1/appointments --data start_time="12/13/2014"
            #
            #   resp.status
            #   => 400
            #
            #
            def index
                if params[:start_time] or params[:end_time]
                    @appointments = Appointment.where(@condition)                       
                else
                    @appointments = Appointment.all          
                end
                respond_with @appointments, status: 200               
            end

            ##
            # Returns an specific appointment
            #
            # GET /api/v1/appointments/:id
            #
            #
            # = Examples (using cURL)
            #
            #   curl --request GET http://localhost:3000/api/v1/appointments/1
            #
            #   resp.status
            #   => 200
            #
            #   resp.body
            #   => {"id":1,"first_name":"ale","last_name":"paredes","comment":"","start_time":"2014-04-12T22:03:00.000Z",
            #        "end_time":"2014-04-12T23:03:00.000Z","created_at":"2014-04-12T21:05:00.000Z","updated_at":"2014-04-12T21:05:00.000Z"}
            #   
            #   curl --request GET http://localhost:3000/api/v1/appointments/300
            #
            #   resp.status
            #   => 404
            #
            #
            def show
                respond_with @appointment, status: 200
            end

            ##
            # Creates an appointment
            #
            #  POST /api/v1/appointments
            #
            # params:
            #   appointment[first_name] - +String+ First name of the person
            #   appointment[last_name]  - +String+ Last name of the person
            #   appointment[start_time] - +DateTime+ Start time of the appointment. Must be greater than now. Recommended to use ISO 8601 formats
            #   appointment[end_time]   - +DateTime+ End time of the appointment. Must be greater than start_time. Recommended to use ISO 8601 formats
            #   appointment[comment]    - [optional] +String+ Appointment's comment
            #
            # = Examples (using cURL)
            #
            #   curl --request POST http://localhost:3000/api/v1/appointments --data appointment[first_name]="Bruce" 
            #       --data appointment[last_name]="Wayne" --data appointment[start_time]="2014-04-12T15:15:00" 
            #       --data appointment[end_time]="2014-04-12T15:55:00" --data appointment[comment]="top secret"
            #
            #   resp.status
            #   => 201
            #
            #   resp.body
            #   => {"id":2,"first_name":"Bruce","last_name":"Wayne","comment":"top secret","start_time":"2014-04-13T15:15:00.000Z",
            #       "end_time":"2014-04-13T15:55:00.000Z","created_at":"2014-04-13T03:10:36.646Z","updated_at":"2014-04-13T03:10:36.646Z"}
            #   
            #   curl --request POST http://localhost:3000/api/v1/appointments --data appointment[first_name]="" 
            #
            #   resp.status
            #   => 422
            #
            #   resp.body
            #   => {"errors":{"first_name":["can't be blank"],"last_name":["can't be blank"],
            #       start_time":["can't be blank"],"end_time":["can't be blank"]}}
            #
            def create
                @appointment = Appointment.new(appointment_params)       
                if @appointment.save
                    respond_with @appointment, location: api_v1_appointment_path(@appointment), status: 201
                else
                    respond_with @appointment, status: 422 
                end                  
            end

            ##
            # Udates an appointment
            #
            #  PUT /api/v1/appointments/:id
            #
            # params:
            #   first_name - +String+ First name of the person
            #   last_name  - +String+ Last name of the person
            #   start_time - +DateTime+ Start time of the appointment. Must be greater than now. Recommended to use ISO 8601 formats
            #   end_time   - +DateTime+ End time of the appointment. Must be greater than start_time. Recommended to use ISO 8601 formats
            #   comment    - +String+ Appointment's comment
            #
            # = Examples (using cURL)
            #
            #   curl --request PUT http://localhost:3000/api/v1/appointments/1 --data appointment[first_name]="Peter" 
            #       --data appointment[last_name]="Paker" 
            #
            #   resp.status
            #   => 204
            #
            #   
            #   curl --request PUT http://localhost:3000/api/v1/appointments/1 --data appointment[start_time]="2013-04-12T15:15:00"
            #
            #   resp.status
            #   => 422
            #
            #   resp.body
            #   => {"errors":{"start_time":["Start time must be greater than current time"]}}
            #
            def update 
                if @appointment.update_attributes(appointment_params)       
                    respond_with @appointment, status: 204
                else
                    respond_with @appointment, status: 422 
                end 
            end

            ##
            # Destroys an appointment
            #
            #  DELETE /api/v1/appointments/:id
            #
            # = Examples (using cURL)
            #
            #   curl --request DELETE http://localhost:3000/api/v1/appointments/1 
            #
            #   resp.status
            #   => 204
            #
            #
            def destroy
                @appointment.destroy
                respond_with @appointment, status: 204
            end

            private

                def find_appointment
                    @appointment = Appointment.find(params[:id])

                    rescue ActiveRecord::RecordNotFound  => e
                        errors = {"errors" => e.message}
                        respond_with errors, status: 404
                end

                def appointment_params
                   if params[:appointment]
                    params.require(:appointment).permit(:first_name, :last_name, 
                            :start_time, :end_time, :comment)
                   end
                end

                def validate_and_transform(time)

                    return time.to_datetime
                    
                    rescue ArgumentError => e
                        errors = {"errors" => { time => e.message}}
                        respond_with errors, status: 400  
                end

                def build_list_filter
                    start_time = validate_and_transform(params[:start_time]) if params[:start_time]
                    end_time = validate_and_transform(params[:end_time]) if params[:end_time]
                    if start_time and end_time
                      @condition = ['start_time >= ? and end_time <= ?', start_time, end_time]
                    elsif start_time
                      @condition = ['start_time >= ?', start_time]
                    elsif end_time
                      @condition = ['end_time <= ?',end_time]
                    end     
                end

        end
    end 
end