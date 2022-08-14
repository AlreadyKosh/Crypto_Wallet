module ApplicationHelper
    #CONVERTE A DATA 
    def data_br(data_us)
        data_us.strftime("%d/%m/%Y")
    end

    def locale
        I18n.locale == :en ? "Estados Unidos" : "Português do Brasil"
    end

    #Verifica Qual O ambiente que está sendo utilizado
    def ambiente_rails
        if Rails.env.development?
            "Desenvolvimento"
        elsif Rails.env.production?
            "Produção"
        else
            "Teste"
        end
    end
end
