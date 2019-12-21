# frozen_string_literal: true

require "singleton"

class RedmineApi
  class RedmineApiError < StandardError; end

  def initialize(host, secret)
    @host = host
    @signer = ParameterSigner.new(secret: secret)
    @client = Faraday.new("#{host}/red_refinery") do |faraday|
      faraday.request :json
      faraday.options[:open_timeout] = 2
      faraday.options[:timeout] = 5

      faraday.response :logger if Rails.application.config.log_level == :debug
      # faraday.response :json # It will Faraday::ParsingError when response no content

      faraday.adapter Faraday.default_adapter
    end
  end

  def ping
    response = @client.post(
      "hooks/ping",
      signer.signed_params
    )

    if response.status == 500
      raise RedmineApiError, "Unexpected return code 500"
    end

    body =
      begin
        JSON.parse(response.body).with_indifferent_access
      rescue
        raise RedmineApiError, "Parse body error -- #{response.body}"
      end

    if body[:status] == "ok"
      true
    else
      false
    end
  end

  SUPPORT_ISSUE_PARAM_KEYS = %i[
    is_private tracker_id subject description
    status_id priority_id assigned_to_id parent_issue_id
    start_date due_date estimated_hours done_ratio notes private_notes
  ]
  SUPPORT_TIME_ENTRY_PARAM_KEYS = %i[
    hour activity_id comments
  ]

  def update_issue(user_id:, issue_id:, issue_params: {}, time_entry_params: {})
    params = {
      user_id: user_id,
      issue_id: issue_id,
      issue: issue_params.slice(*SUPPORT_ISSUE_PARAM_KEYS).transform_values(&:to_s),
      time_entry: time_entry_params.slice(*SUPPORT_TIME_ENTRY_PARAM_KEYS).transform_values(&:to_s)
    }

    response = @client.post(
      "hooks/update_issue",
      signer.signed_params(params)
    )

    if response.status == 500
      raise RedmineApiError, "Unexpected return code 500"
    end

    body =
      begin
        JSON.parse(response.body).with_indifferent_access
      rescue
        raise RedmineApiError, "Parse body error -- #{response.body}"
      end

    if body[:status] == "ok"
      true
    else
      false
    end
  end

  private

    attr_reader :client, :host, :signer
end
