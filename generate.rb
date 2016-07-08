require 'csv'

# The SCR used fpr calculations.
$surface_consumption_rate = 20 # in l/min

# All values in liters, need to be 5
# If you want less then 5 (or more) you need to change the .tex
liters = [10, 11, 12, 15, 'D12']

# Depths in meters, can be up to seven values.
depths = [10, 15, 20, 25, 30, 35]

### Should not be changed!
$minimum_pressure_threshold = 40 # in bar
$ascension_rate = 3 # in m/min
$time_to_solve_problem = 1 # in min

def time_to_ascend(depth)
  return (depth/$ascension_rate) + $time_to_solve_problem
end

def average_pressure(depth)
  (depth/20) + 1
end

def minimum_gas(depth)
  (2*$surface_consumption_rate) * time_to_ascend(depth) * average_pressure(depth)
end

def minimum_pressure(depth, liter)
  pressure = minimum_gas(depth) / liter
  if pressure < $minimum_pressure_threshold
    $minimum_pressure_threshold
  else
    pressure + (10 - (pressure % 10))
  end
end


# minimum gas data calculation
CSV.open('./tmp/minimum_gas.csv', 'wb') do |csv|
  # header, show Number + 'l' or D12 without 'l'
  csv << (liters.map { |l| l.to_s[0..0] == 'D' ? l.to_s : l.to_s + 'l'}).unshift(nil)
  # convert D## => liters
  # i.e. D12 => 24
  #       D7 => 14
  liters.map! { |l| l.to_s[0..0] == 'D' ? l[1..-1].to_i * 2 : l}
  depths.each do |d|
    csv << (liters.map { |l| minimum_pressure(d, l) }).unshift(d.to_s + 'm')
  end
end

# puts $surface_consumption_rate # for getting it into latex
File.write('./tmp/scr.tmp', $surface_consumption_rate)
