# lib/tasks/import_result_quizzes.rake
namespace :import do
  desc "Importa resultado do questionário de um arquivo CSV para a tabela ResultQuiz"
  task result_quizzes: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de resultado do questionário do arquivo: #{file_path}"

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando ID do cliente: #{row['customer_id']}"

        result_quiz = ResultQuiz.new(
          customer_id: row['customer_id'],
          axi_id: row['axi_id'],
          maturity_id: row['maturity_id'],
          average_score: row['average_score'],
          created_at: row['created_at'],
          updated_at: row['updated_at']
        )

        if result_quiz.save
          puts "Resultado do questionário #{row['customer_id']} importado com sucesso."
        else
          puts "Erro ao importar o resultado do questionário #{row['customer_id']}: #{result_quiz.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de resultado do questionário concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
