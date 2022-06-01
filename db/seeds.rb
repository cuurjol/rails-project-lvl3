# frozen_string_literal: true

I18n.locale = :en

unless Category.exists?
  category_names = %w[Music Clothes Books Vehicle Furniture Animals]
  category_names.each { |name| Category.create!(name: name) }
end

unless User.admin.exists?
  params = { name: 'Admin User', email: ENV.fetch('ADMIN_EMAIL', nil), password: ENV.fetch('ADMIN_PASSWORD', nil),
             password_confirmation: ENV.fetch('ADMIN_PASSWORD', nil), admin: true }
  User.create!(params)
end

unless User.not_admin.exists?
  auth = Faker::Omniauth.google
  password = SecureRandom.uuid
  params = { name: auth[:info][:name], email: auth[:info][:email],
             password: password, password_confirmation: password }
  User.create!(params)
end

unless Bulletin.exists?
  user = User.not_admin.last
  categories = Category.all
  aasm_states = Bulletin.aasm.states.map(&:name)

  1.upto(120) do |i|
    category = categories.sample
    image_io = File.open(Rails.root.join("test/fixtures/files/#{category.name.downcase}.jpg"))
    params = { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, state: aasm_states.sample,
               category: category, user: user }
    bulletin = Bulletin.new(params)
    bulletin.image.attach(io: image_io, filename: "#{category.name.downcase}_#{i}.jpg", content_type: 'image/jpeg')
    bulletin.save!
  end
end
