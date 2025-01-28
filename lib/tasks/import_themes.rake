# lib/tasks/import_themes.rake
namespace :import do
  desc "Importa temas de um arquivo CSV para a tabela Themes"
  task themes: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de temas eixos do arquivo: #{file_path}"

      # Deletar todos os registros da tabela axis

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando name: #{row['name']}"

        theme = Theme.new(
          axi_id: row['axi_id'],
          name: row['name'],
          created_at: row['created_at'],
          updated_at: row['updated_at']
        )

        if theme.save
          puts "Eixo #{row['name']} importado com sucesso."
        else
          puts "Erro ao importar o eixo #{row['name']}: #{theme.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de temas concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
