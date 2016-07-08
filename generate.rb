require 'csv'
require 'mathn'

# The SCR used fpr calculations.
$surface_consumption_rate = 20 # in l/min

# All values in liters, need to be 5
# If you want less then 5 (or more) you need to change the .tex
liters = [10, 11, 12, 15, 'D12']

# Depths in meters, can be up to seven values.
depths = [10, 15, 20, 25, 30, 40]

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
  min_pressure = minimum_gas(depth) / liter
  if min_pressure < $minimum_pressure_threshold
    $minimum_pressure_threshold
  else
    min_pressure + (10 - (min_pressure % 10))
  end
end

def gas_consumption(depth, liter)
  pressure = depth/10 + 1
  result = ($surface_consumption_rate * pressure * 5) / liter
  (result / 5).round * 5
end


liters_heading = liters
liters.map! { |l| l.to_s[0..0] == 'D' ? l[1..-1].to_i * 2 : l}
# minimum gas data calculation
CSV.open('./tmp/minimum_gas.csv', 'wb') do |csv|
  # header, show Number + 'l' or D12 without 'l'
  csv << (liters_heading.map { |l| l.to_s[0..0] == 'D' ? l.to_s : l.to_s + '\ell'}).unshift(nil)
  # convert D## => liters
  # i.e. D12 => 24
  #       D7 => 14
  depths.each do |d|
    csv << (liters.map { |l| minimum_pressure(d, l) }).unshift(d.to_s + 'm')
  end
end

# minimum gas data calculation
CSV.open('./tmp/gas_consumption.csv', 'wb') do |csv|
  # header, show Number + 'l' or D12 without 'l'
  csv << (liters_heading.map { |l| l.to_s[0..0] == 'D' ? l.to_s : l.to_s + '\ell'}).unshift(nil)
  # convert D## => liters
  # i.e. D12 => 24
  #       D7 => 14
  depths.each do |d|
    csv << (liters.map { |l| gas_consumption(d, l) }).unshift(d.to_s + 'm')
  end
end

# puts $surface_consumption_rate # for getting it into latex
File.write('./tmp/scr.tmp', $surface_consumption_rate)
