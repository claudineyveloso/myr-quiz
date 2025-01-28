# lib/tasks/import_answers.rake
namespace :import do
  desc "Importa respostas de um arquivo CSV para a tabela Answers"
  task answers: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de respostas do arquivo: #{file_path}"

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando ID do cliente : #{row['customer_id']}"

        answer = Answer.new(
          customer_id: row['customer_id'],
          theme_id: row['theme_id'],
          scenario_id: row['scenario_id'],
          created_at: row['created_at'],
          updated_at: row['updated_at']
        )

        if answer.save
          puts "Resposta do cliente #{row['customer_id']} importado com sucesso."
        else
          puts "Erro ao importar o eixo #{row['customer_id']}: #{answer.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação das respostas concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
