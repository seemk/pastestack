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

end
