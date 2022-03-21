namespace :dev do
  desc "Configurando o ambiente de desenvolvimento"
  task setup: :environment do

    puts "Resetando o BD..."
    %x(rails db:drop db:create db:migrate)
    puts "BD criado!"

    puts "Cadastrando os tipos..."
    kinds = %w(Amigo Conhecido Comercial)
    kinds.each do |kind|
      Kind.create!(description: kind)
    end
    puts "Tipos cadastrados com sucesso!"

    puts "Cadastrando os contatos..."
    100.times do
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(from: 70.years.ago, to: 18.years.ago),
        kind: Kind.all.sample
      )
    end
    puts "Contatos cadastrados com sucesso!"

    puts "Cadastrando os telefones..."
    Contact.all.each do |contact|
      Random.rand(5).times do |i|
        phone = Phone.create!(number: Faker::PhoneNumber.cell_phone)
        contact.phones << phone
        contact.save!
      end
    end
    puts "Telefones cadastrados com sucesso!"

    puts "Cadastrando os endereços..."
    Contact.all.each do |contact|
      Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        contact: contact
      )
    end
    puts "Endereços cadastrados com sucesso!"
    
  end
end
