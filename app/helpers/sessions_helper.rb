module SessionsHelper

    # Здійснює вхід даного користувача
    def log_in(user)
        session[:user_id] = user.id
    end

    # Повертає даного юзера,ї, якщо той є
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id]) 
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def logged_in?
        current_user
        !@current_user.nil?
    end

    # Здійснює вихід юзера
    def log_out
        session.delete(:user_id)
        current_user = nil
    end

    # запамятовує юзера в постійному сеансі
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Повертає true якщо даний користувач є поточним
    def current_user?(user)
        user == current_user
    end

    # Перенаправити по збереженому адресу або на сторінку по замовчуванні
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    # Запамятовує URL
    def store_location
        session[:forwarding_url] = request.url if request.get?
    end

end
