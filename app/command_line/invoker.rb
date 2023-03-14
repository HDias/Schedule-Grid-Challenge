# frozen_string_literal: true

module CommandLine
  class Invoker
    attr_writer :on_start

    def initialize
      message = "********************************************\n" \
                "******Grade de Programação******************\n" \
                "********************************************\n" \

      puts message
    end

    def help_message
      save_command = %(S "<região>" "<nome do programa>" <início> <fim>\n)
      save_command_ex = %(S "GO" "Programa A" 09:00 10:15\n)
      query_command = %(Q "<região>" <hora>\n)
      query_command_ex = %(Q "DF" 09:00\n)

      "\n" \
        "Comandos aceitos:\n" \
        "\n" \
        "Para salvar nova grade:\n" \
        "#{save_command}" \
        "Ex.: #{save_command_ex}" \
        "\n" \
        "Para consultar grade:\n" \
        "#{query_command}" \
        "Ex.: #{query_command_ex}" \
        "\n" \
        "Sair:\n" \
        "exit\n" \
        "\n" \
        "Limpar:\n" \
        "clear\n" \
        "\n" \
        "Ajuda:\n" \
        "help\n" \
        "\n" \
    end

    def execute
      response = @on_start.execute

      response.each { |r| puts r }
    end
  end
end
