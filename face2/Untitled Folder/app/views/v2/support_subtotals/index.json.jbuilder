json.support_subtotals do
  json.array! (0..(Settings.month_displaying_support_subtotal - 1))
   .to_a do |i|
    datetime = Time.zone.now - (i + 1).month
    if @support_subtotals[i].try(:targeted_at) ==  datetime.beginning_of_month
      json.supporters_count @support_subtotals[i].supporters_count
      json.month @support_subtotals[i].targeted_at.strftime "%m, %Y"
    else
      json.supporters_count 0
      json.month datetime.strftime "%m, %Y"
    end
  end
end
