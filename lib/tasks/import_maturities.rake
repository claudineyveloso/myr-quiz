# lib/tasks/import_maturities.rake
namespace :import do
  desc "Importa maturidades de um arquivo CSV para a tabela Maturities"
  task maturities: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de maturidades do arquivo: #{file_path}"

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando name: #{row['name']}"

        maturity = Maturity.new(
          name: row['name'],
          value: row['value'],
          created_at: row['created_at'],
          updated_at: row['updated_at'],
          range_initial: row['range_initial'],
          range_final: row['range_final'],
          description_result: row['description_result'],
        )

        if maturity.save
          puts "Maturidade #{row['name']} importado com sucesso."
        else
          puts "Erro ao importar o maturidade #{row['name']}: #{maturity.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de maturidades concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
