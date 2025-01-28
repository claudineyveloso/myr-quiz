# lib/tasks/import_users.rake
namespace :import do
  desc "Importa usuários de um arquivo CSV para a tabela Users"
  task users: :environment do
    require 'csv'

    file_path = ENV['FILE']
    if file_path.nil?
      puts "Por favor, forneça o caminho do arquivo CSV usando FILE=<caminho_do_arquivo>"
      exit
    end

    begin
      puts "Iniciando importação de usuários do arquivo: #{file_path}"

      # Deletar todos os registros da tabela users
      User.delete_all

      # Abrir e iterar sobre o arquivo CSV
      CSV.foreach(file_path, headers: true) do |row|
        puts "Importando email: #{row['email']}"

        user = User.new(
          email: row['email'],
          password: 12345678, # row['encrypted_password'],
          is_active: 1,  # Forçando is_active para 1 (verdadeiro)
          user_type: row['user_type']
        )

        if user.save
          puts "Usuário #{row['email']} importado com sucesso."
        else
          puts "Erro ao importar o usuário #{row['email']}: #{user.errors.full_messages.join(', ')}"
        end
      end

      puts "Importação de usuários concluída com sucesso!"
    rescue StandardError => e
      puts "Erro durante a importação: #{e.message}"
    end
  end
end
