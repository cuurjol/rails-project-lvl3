# frozen_string_literal: true

module UserAuthorizationHelper
  def assert_no_pundit_authorization(policy_name, policy_query, &block)
    instance_exec(&block)
    assert_response(:redirect)
    assert_redirected_to(root_url)
    assert { flash[:alert] == I18n.t("#{policy_name}.#{policy_query}", scope: :pundit) }
  end

  def assert_no_admin_authorization(&block)
    instance_exec(&block)
    assert_response(:redirect)
    assert_redirected_to(root_url)
    assert { flash[:alert] == I18n.t('web.admin.application.user_admin.failure') }
  end
end
