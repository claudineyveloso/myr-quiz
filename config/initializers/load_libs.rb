Rails.application.config.to_prepare do
  Dir[Rails.root.join('lib', 'rails_admin', '*.rb')].each { |file| require file }
end
