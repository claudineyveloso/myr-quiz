# lib/tasks/import_customers.rake
namespace :import do
  desc "Importa clientes de um arquivo CSV para a tabela Customers"
  task customers: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de clientes do arquivo: #{file_path}"

      # Deletar todos os registros da tabela clientes

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando name: #{row['name']}"

        customer = Customer.new(
          name: row['name'],
          email: row['email'],
          phone: row['phone'],
          company_name: row['company_name'],
          cnpj: row['cnpj'],
          created_at: row['created_at'],
          updated_at: row['updated_at'],
          finished_quiz: row['finished_quiz'],
          satisfaction_score: row['satisfaction_score'],
          comment: row['comment'],
          access_url: row['access_url']
        )

        if customer.save
          puts "Cliente #{row['name']} importado com sucesso."
        else
          puts "Erro ao importar o cliente  #{row['name']}: #{customer.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de clientes concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
