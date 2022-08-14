namespace :dev do
  desc "Configura o Ambiente de Desenvolvimento"
  task setup: :environment do
    if Rails.env.development?

      show_spinner("Apagando DB...") { %x(rails db:drop) }
      show_spinner("Criando DB...") { %x(rails db:create) }
      show_spinner("Migrando DB...") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types) 
      %x(rails dev:add_coins) 
    else
      puts "Você não está no ambiente de desenvolvimento"
    end
  end

  desc "Cadastras as Moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando Moedas...") do
      #Array das Moedas
      coins = [
          {
              description: "Bitcoin",
              acronym: "BTC",
              url_image: "http://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png",
              mining_type: MiningType.find_by(acronym: 'PoW')
          },
          {
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/471px-Ethereum_logo_2014.svg.png",
              mining_type: MiningType.all.sample
          },
          {
              description: "Dash",
              acronym: "DASH",
              url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png",
              mining_type: MiningType.all.sample
          }
      ]

      #Passa por cada moeda do array e cria caso não exista.
      coins.each do |coin|
          Coin.find_or_create_by!(coin) #Procura se o elemento já existe, caso não ele cria.
      end
    end
  end

  desc "Cadastra os Tipos de Mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando Tipos de Mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type) #Procura se o elemento já existe, caso não ele cria.
      end
    end
  end
 


  private
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")     #Mostra no terminal a mensagem e um spinner carregando
    spinner.auto_spin
    yield  #É UM BLOCO DE CÓDIGO QUE SERÁ PASSADO
    spinner.success("(#{msg_end})") #Mostra no terminal a mensagem com um Check
  end 

end
