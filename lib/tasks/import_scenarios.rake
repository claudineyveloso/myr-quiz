# lib/tasks/import_scenarios.rake
namespace :import do
  desc "Importa cenários de um arquivo CSV para a tabela Scenarios"
  task scenarios: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação dos cenários do arquivo: #{file_path}"

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando email: #{row['desciption']}"

        scenario = Scenario.new(
          theme_id: row['theme_id'],
          maturity_id: row['maturity_id'],
          description: row['description'],
          created_at: row['created_at'],
          updated_at: row['updated_at']
        )

        if scenario.save
          puts "Cenário #{row['description']} importado com sucesso."
        else
          puts "Erro ao importar o cenário #{row['description']}: #{scenario.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de cenários concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
