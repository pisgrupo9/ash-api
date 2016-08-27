SimpleTokenAuthentication.configure do |config|

  # Configure the session persistence policy after a successful sign in,
  # in other words, if the authentication token acts as a signin token.
  # If true, user is stored in the session and the authentication token and
  # email may be provided only once.
  # If false, users must provide their authentication token and email at every request.
  config.sign_in_token = false

  # Configure the name of the HTTP headers watched for authentication.
  #
  # Default header names for a given token authenticatable entity follow the pattern:
  #   { entity: { authentication_token: 'X-Entity-Token', email: 'X-Entity-Email'} }
  #
  # When several token authenticatable models are defined, custom header names
  # can be specified for none, any, or all of them.
  #
  # Examples
  #
  #   Given User and SuperAdmin are token authenticatable,
  #   When the following configuration is used:
  #     `config.header_names = { super_admin: { authentication_token: 'X-Admin-Auth-Token' } }`
  #   Then the token authentification handler for User watches the following headers:
  #     `X-User-Token, X-User-Email`
  #   And the token authentification handler for SuperAdmin watches the following headers:
  #     `X-Admin-Auth-Token, X-SuperAdmin-Email`
  #
  config.header_names = { user: {
    authentication_token: 'X-User-Token',
    email: 'X-User-Email'
  } }
end

module SimpleTokenAuthentication
  Entity.class_eval do
    def auth_provider(headers)
      :email
    end

    def identifier_header_name(headers)
      header_name = SimpleTokenAuthentication.header_names["#{name_underscore}".to_sym]
      identifier_header_name = header_name[auth_provider(headers)]
      if header_name.presence && identifier_header_name
        identifier_header_name
      else
        "X-#{name}-Email"
      end
    end

    def identifier_param_name(headers)
      "#{name_underscore}_#{auth_provider(headers)}".to_sym
    end

    def get_identifier_from_params_or_headers(controller)
      # if the identifier is not present among params, get it from headers
      headers = controller.request.headers
      params_name = identifier_param_name(headers)
      controller_params_name = controller.params[params_name]
      identifier = controller_params_name.blank? && headers[identifier_header_name(headers)]
      controller_params_name = identifier if identifier
      controller_params_name
    end
  end
end

module SimpleTokenAuthentication
  TokenAuthenticationHandler.module_eval do
    def find_record_from_identifier(entity)
      identifier = entity.get_identifier_from_params_or_headers(self).presence

      # Rails 3 and 4 finder methods are supported,
      # see https://github.com/ryanb/cancan/blob/1.6.10/lib/cancan/controller_resource.rb#L108-L111
      identifier && entity.model.where(entity.auth_provider(request.headers) => identifier).first
    end
  end
end
