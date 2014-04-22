require 'pry'

module Helper
  def yday_check (day)
    if day.yday <= 7
      return day.yday + 365
    else
      return day.yday
    end
  end

  def hash_date_maker (epoch_date)
    "#{epoch_date.strftime('%A')}, #{epoch_date.strftime('%B')} #{epoch_date.strftime('%e')}, #{epoch_date.strftime('%Y')}"
  end
end
