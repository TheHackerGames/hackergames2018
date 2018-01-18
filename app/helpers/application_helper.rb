module ApplicationHelper
  def format_time(time, format: :long)
    return unless time.present?
    if format.is_a?(String)
      time.strftime(format)
    else
      time.to_formatted_s(format)
    end
  end
end
