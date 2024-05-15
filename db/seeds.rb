User.create!(
  id: 1,
  name: "tamam",
  password: ENV['TAMAM_PASSWORD'],
  password_confirmation: ENV['TAMAM_PASSWORD']
)
