require 'csv'
require 'date'
require 'gruff' 


# read log data from a log file
def read_from_file filename
  data = CSV.read(filename)
  data.map do |row|
    [ DateTime.strptime(row[0], '%Y-%m-%d %H:%M:%s'), row[1].to_i, row[2].to_i ]
  end
end

# Format graph (label style etc.)
class Gruff::Base
  def layout_graph
    @x_label_margin = 40
    @bottom_margin = 60
    @disable_significant_rounding_x_axis = true
    @use_vertical_x_labels = true
    @marker_x_count = 10 # One label every month

    @circle_radius = 2.0
    @marker_font_size = 10

    @font = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf' 

    #enable_vertical_line_markers = true
    #y_axis_increment = 1
    #stroke_width = 0.01
  end
end

class Array
  def avg
    reduce(:+) / size.to_f
  end
end

puts 'Preprocessing data...'
data_by_weekday = read_from_file('unifitstats.csv')
  .map! { |date, hr, vcnt| [ date.strftime('%A'), hr, vcnt ]}
  .group_by { |wkday, _| wkday }
  .map { |wkday, dts| [ wkday, dts.group_by { |_, hr, _| hr } ] }
  .to_h
  .map { |wkday, dts| [ wkday, dts.map { |_, crs| crs.map { |_, _, vcnt| vcnt }.avg } ] }
  .to_h

# p data_by_weekday

puts 'Drawing graph...'
graph = Gruff::Line.new('1500x900')
graph.title = 'Unifit average visitors'

data_by_weekday.each do |day, vdata|
  graph.data(day, vdata) unless day == "Sunday"
end

graph.layout_graph
graph.labels = Hash.new { |h, k| h[k] = k.to_s }
graph.hide_legend = false
graph.maximum_value = 25
graph.minimum_value = 0.0
graph.x_axis_label = "Time of day"
graph.y_axis_label = "Average visitors"
theme = Gruff::Themes::KEYNOTE
theme[:background_colors] = '#2E3436'
graph.theme = theme
graph.write('plots/unifitstats.png')

puts 'Finished.'