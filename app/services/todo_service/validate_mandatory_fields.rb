# frozen_string_literal: true

module TodoService
  class ValidateMandatoryFields < BaseService
    def initialize(params)
      @title = params[:title]
      @due_date = params[:due_date]
    end

    def call
      missing_fields = []
      missing_fields << I18n.t('activerecord.errors.messages.blank', attribute: 'title') if @title.blank?
      missing_fields << I18n.t('activerecord.errors.messages.blank', attribute: 'due_date') if @due_date.blank?
      missing_fields
    end
  end
end

# Load I18n and the BaseService class
I18n.load_path << Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
I18n.default_locale = :en

# Assuming BaseService is already defined and loaded by Rails
# If not, require the necessary file
