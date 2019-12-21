# frozen_string_literal: true

class ParameterSigner
  attr_reader :secret

  def initialize(secret:)
    @secret = secret
  end

  MAX_TIMESTAMP_INTERVAL = 60

  def valid?(params)
    return false if params.blank?

    timestamp = params.delete(:timestamp).to_i
    interval = Time.now.to_i - timestamp
    return false if interval < 0
    return false if interval > MAX_TIMESTAMP_INTERVAL

    signature = params.delete(:signature)
    return false if signature.blank?

    params_string =
      if params.any?
        "#{sorted_stringify_params(params)}&timestamp=#{timestamp}&#{secret}"
      else
        "timestamp=#{timestamp}&#{secret}"
      end

    Digest::SHA256.hexdigest(params_string) == signature
  end

  def signed_params(params = {})
    timestamp = params.delete(:timestamp) || Time.now.to_i
    params_string =
      if params.any?
        "#{sorted_stringify_params(params)}&timestamp=#{timestamp}&#{secret}"
      else
        "timestamp=#{timestamp}&#{secret}"
      end

    params.merge timestamp: timestamp, signature: Digest::SHA256.hexdigest(params_string)
  end

  private

    def sorted_stringify_params(params, prefix = nil)
      params.sort.map do |k, v|
        if v.is_a? Hash
          sorted_stringify_params(v, k)
        elsif v.is_a? Array
          # TODO: We don't have `array` type value yet
          raise NotImplementedError, "We don't support array type param."
        else
          "#{[prefix, k].compact.join(".")}=#{v}"
        end
      end.join("&")
    end
end
