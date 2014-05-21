module PastesHelper

    def content_lines(paste)
        paste.content.split("\n")
    end

    def exposure_str(paste)
        case paste.exposure
        when 0
            "Private"
        when 1
            "Public"
        else
            "unspecified"
        end
    end

    def recent_pastes
        Paste.where{exposure >= 1}.last(20).reverse
    end

    def exposure_selection
        if signed_in?
            [['Public', 1], ['Private', 0]]
        else
            [['Public', 1]]
        end
    end

    def available_languages
        langs = ['C++', 'Python', 'Java', 'Ruby', 'HTML',
         'JavaScript', 'Go', 'C', 'XML', 'PHP', 'Lua', 'Groovy',
         'YAML', 'SQL', 'Clojure', 'CSS', 'JSON']
         
        langs.sort!
        langs.unshift("None")
    end

    def clear_anonymous_pastes
        cookies.delete(:anon_pastes)
    end

    # Stores pastes created anonymously in the cookies
    # on log in / sign up, assigns these to the user.
    # Silliest requirement ever.
    def store_anonymous_paste(paste)
        existing = cookies[:anon_pastes]
        existing ||= []
        existing << paste.id
        cookies.permanent.signed[:anon_pastes] = existing
    end

    def bind_anonymous_pastes(user)
        return if user.nil?
        paste_ids = cookies.signed[:anon_pastes]
        return if paste_ids.nil?
        pastes = Paste.where{id.in paste_ids} 
        Rails.logger.debug "Stored pastes: #{pastes}"
        pastes.each { |p| p.update_attribute(:user_id, user.id) }
        clear_anonymous_pastes
    end
    
end
