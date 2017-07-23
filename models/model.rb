require_relative 'hash'

class Fact
  def initialize(state, date)
    @state = state.to_s
    @date = date.split("/")
    @COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def days_in_month(year = Time.now.year)
    return 29 if @date[0] == 2 && Date.gregorian_leap?(year)
    @COMMON_YEAR_DAYS_IN_MONTH[@date[0].to_i]
  end
  
  def get_fact
#     $choice1 = []
#     $choice2 = []
#     x = @date[1].to_i
    for i in @date[1].to_i..days_in_month
      if $state_hash[@state].has_key?("#{@date[0]}/#{i.to_s}") == true
      return $state_hash[@state]["#{@date[0]}/#{i.to_s}"]
      break
      else
      end
    end
#     while x > 0
#       if $state_hash[@state].has_key?("#{@date[0]}/#{x.to_s}") == true
#         $choice2 = $state_hash[@state]["#{@date[0]}/#{x.to_s}"]
#         $choice2date = x
#         break
#       else
#       end
#       x-=1
#     end
#     if ($choice1date.to_i - @date[1].to_i) <= (@date[1].to_i - $choice2date.to_i)
#       return $choice1
#     else
#       return $choice2
#     end
  end
end
    