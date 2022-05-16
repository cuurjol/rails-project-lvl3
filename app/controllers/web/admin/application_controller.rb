# frozen_string_literal: true

module Web
  module Admin
    class ApplicationController < Web::ApplicationController
      private

      def policy_scope(scope)
        super([:admin, scope])
      end

      def authorize(record, query = nil)
        super([:admin, record], query)
      end
    end
  end
end
