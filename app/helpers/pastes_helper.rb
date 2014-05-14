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
    
end
