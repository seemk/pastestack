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
        Paste.last(20).reverse
    end
    
end
