# Defines FactoryBot sequences
FactoryBot.define do
  sequence :email do |n|
    "person#{SecureRandom.hex(n)}@example.com"
  end
end
