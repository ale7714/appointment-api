require 'csv'

csv_file_path = 'db/data.csv'
CSV.foreach(csv_file_path,{:headers=>true}) do |row|
    appointment = Appointment.new(start_time: DateTime.strptime(row[0], "%m/%d/%y %H:%M"),
                              end_time: DateTime.strptime(row[1], "%m/%d/%y %H:%M"),
                              first_name: row[2],
                              last_name: row[3])
    if appointment.valid?
        appointment.save
        puts "Appointment added: #{appointment.first_name} #{appointment.last_name}"
    else
        puts appointment.errors.to_a
    end
end
