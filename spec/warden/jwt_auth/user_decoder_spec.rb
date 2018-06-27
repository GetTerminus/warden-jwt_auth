# frozen_string_literal: true

require 'spec_helper'

describe Warden::JWTAuth::UserDecoder do
  include_context 'configuration'
  include_context 'fixtures'

  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user) }
  let(:payload) { Warden::JWTAuth::TokenDecoder.new.call(token) }

  describe '#call(token, scope)' do
    it 'returns encoded user' do
      expect(
        described_class.new.call(token, :user)
      ).to eq(user)
    end

    it 'raises RevokedToken if the token has been revoked' do
      revocation_strategies[:user].revoke_jwt(payload, user)

      expect do
        described_class.new.call(token, :user)
      end.to raise_error(Warden::JWTAuth::Errors::RevokedToken)
    end

    it 'raises WrongScope if encoded token does not match with intended one' do
      expect do
        described_class.new.call(token, :unknown)
      end.to raise_error(Warden::JWTAuth::Errors::WrongScope)
    end

    context 'when scope is not specified' do
      let(:token_payload) { Warden::JWTAuth::UserEncoder.new.call(user, nil, 'aud') }

      it 'returns encoded user' do
        expect(
          described_class.new.call(token, :user)
        ).to eq(user)
      end
    end
  end
end
