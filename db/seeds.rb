# frozen_string_literal: true

unless Category.exists?
  category_names = %w[Music Clothes Books Vehicle Furniture]
  category_names.each { |name| Category.create(name: name) }
end

unless User.exists?(admin: true)
  params = { name: 'Admin User', email: 'admin_user_email@example.com', password: '[admin_user_password]',
             password_confirmation: '[admin_user_password]', admin: true }
  User.create(params)
end
