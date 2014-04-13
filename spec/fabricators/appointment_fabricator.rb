Fabricator(:appointment) do
  first_name "John"
  last_name  "Doe"
  comment    "Some comments for the appoinment"
  start_time  {DateTime.now + 10.minutes}
  end_time    {DateTime.now + 60.minutes}
end
