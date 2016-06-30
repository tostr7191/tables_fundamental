require 'csv'

$surface_consumption_rate = 20 # in l/min
$minimum_pressure_threshold = 40 # in bar
$ascension_rate = 3 # in m/min
$time_to_solve_problem = 1 # in m

def time_to_ascend(depth)
  return (depth/$ascension_rate) + $time_to_solve_problem
end

def average_pressure(depth)
  (depth/20) + 1
end

def minimum_gas(depth)
  (2*$surface_consumption_rate) * time_to_ascend(depth) * average_pressure(depth)
end

def minimum_bar(depth, liter)
  bar = minimum_gas(depth) / liter
  if bar < $minimum_pressure_threshold
    $minimum_pressure_threshold
  else
    bar + (10 - (bar % 10))
  end
end



liters = [10, 11, 12, 15, 24, 40]
depths = [10, 15, 20, 25, 30, 35, 40]


CSV.open('./csv/minimum_gas.csv', 'wb') do |csv|
  csv << (liters.map { |l| l.to_s + 'l' }).unshift(nil)
  depths.each do |d|
    csv << (liters.map { |l| minimum_bar(d, l) }).unshift(d.to_s + 'm')
  end
end
