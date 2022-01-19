ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  # Виконує вхід тестового юзера
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
      if integration_test?
        post login_path, params: {session: { email:  user.email,
                                    password: password,
                                    remember_me: remember_me }}
      else
        session[:user_id] = user.id
      end
  end

  private

  # повертає true всередині інтеграційного тесту
  def integration_test?
      defined?(post_via_redirect)
    end
end

