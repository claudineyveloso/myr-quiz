# lib/tasks/import_axis.rake
namespace :import do
  desc "Importa eixos de um arquivo CSV para a tabela Axis"
  task axis: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de eixos do arquivo: #{file_path}"

      # Deletar todos os registros da tabela axis

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando name: #{row['name']}"

        axi = Axi.new(
          name: row['name'],
          created_at: row['created_at'],
          updated_at: row['updated_at'],
          description: row['description'],
        )

        if axi.save
          puts "Eixo #{row['name']} importado com sucesso."
        else
          puts "Erro ao importar o eixo #{row['name']}: #{axi.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de eixos concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
