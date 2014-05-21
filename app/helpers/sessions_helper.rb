module SessionsHelper
    
    def sign_in(user)
        token = User.new_token
        cookies.permanent[:remember_token] = token
        user.update_attribute(:token, User.hash(token))
        bind_anonymous_pastes(user)
        self.current_user = user
    end

    def sign_out
        current_user.update_attribute(:token,
            User.hash(User.new_token))
        cookies.delete(:remember_token)
        self.current_user = nil
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user?(user)
        current_user == user
    end

    def current_user
        token = User.hash(cookies[:remember_token])
        @current_user ||= User.find_by(token: token)
    end

    def signed_in?
        !current_user.nil?
    end

    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.url if request.get?
    end

    def signed_in_user
        unless signed_in?
            store_location
            redirect_to login_url, notice: "Please sign in"
        end
    end

    def admin_rights
        signed_in? && current_user.admin
    end

    def paste_owner(paste)
        admin_rights || (signed_in? && current_user.id == paste.user.id)
    end

end
