# frozen_string_literal: true

module UserAuthorizationHelper
  def assert_no_authorization(&block)
    instance_exec(&block)
    assert_redirected_to(root_url)
  end
end
