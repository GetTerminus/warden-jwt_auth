# frozen_string_literal: true

require 'dry/configurable'
require 'dry/auto_inject'
require 'jwt'
require 'warden'

module Warden
  # JWT authentication plugin for warden.
  #
  # It consists of a strategy which tries to authenticate an user decoding a
  # token present in the `Authentication` header (as `Bearer %token%`).
  # From it, it takes the `sub` claim and provides it to a configured repository
  # of users for the current scope.
  #
  # It also consists of two rack middlewares which perform two actions for
  # configured request paths: dispatching a token for a signed in user and
  # revoking an incoming token.
  module JWTAuth
    extend Dry::Configurable

    # The secret used to encode the token
    setting :secret

    # Expiration time for tokens
    setting :expiration_time, 3600

    # A hash of warden scopes as keys and user repositories as values.
    #
    # @see Interfaces::UserRepository
    # @see Interfaces::User
    setting :mappings, {}

    # Regular expression to match request paths where a JWT token should be
    # added to the `Authorization` response header
    setting :dispatch_paths, nil

    # Regular expression to match request paths where incoming JWT token should
    # be revoked
    setting :revocation_paths, nil

    # Strategy to revoke tokens
    #
    # @see Interfaces::RevocationStrategy
    setting :revocation_strategy

    Import = Dry::AutoInject(config)
  end
end

require 'warden/jwt_auth/version'
require 'warden/jwt_auth/header_parser'
require 'warden/jwt_auth/payload_user_helper'
require 'warden/jwt_auth/user_encoder'
require 'warden/jwt_auth/user_decoder'
require 'warden/jwt_auth/token_encoder'
require 'warden/jwt_auth/token_decoder'
require 'warden/jwt_auth/hooks'
require 'warden/jwt_auth/strategy'
require 'warden/jwt_auth/middleware'
require 'warden/jwt_auth/interfaces'
