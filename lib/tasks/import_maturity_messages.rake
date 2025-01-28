# lib/tasks/import_maturity_messages.rake
namespace :import do
  desc "Importa mensagens da maturidades de um arquivo CSV para a tabela MaturityMessage"
  task maturity_messages: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de mensagens da maturidades do arquivo: #{file_path}"

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando name: #{row['message']}"

        maturity_message = MaturityMessage.new(
          axi_id: row['axi_id'],
          maturity_id: row['maturity_id'],
          message: row['message'],
          created_at: row['created_at'],
          updated_at: row['updated_at']
        )

        if maturity_message.save
          puts "Maturidade #{row['message']} importado com sucesso."
        else
          puts "Erro ao importar o mensagens da maturidade #{row['message']}: #{maturity_message.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de maturidades concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
