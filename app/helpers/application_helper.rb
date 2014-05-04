module ApplicationHelper
  def active_if_matches(regexp)
    "active" if regexp =~ request.path
  end
end
