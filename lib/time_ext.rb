require 'active_support/core_ext/numeric'
class Time
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds).localtime
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
end
