# yes, this is completely fucking retarded looking...not really sure
# what I'm trying to graph here..
get '/reports' do
  # need a group by here...

  @top5cpu = Stat.aggregate(:fields => [:name, :cpu], :order => [:cpu.desc], :limit => 5)
  @top5mem =  Stat.aggregate(:fields => [:name, :mem], :order => [:mem.desc], :limit => 5)

  @cpulist = []
  @cpunames = ""
  @cpuusage = "" 

  @top5cpu.each do |el|
    @cpunames = @cpunames + "|" + el[0]
    @cpulist << el[0]
    @cpuusage = @cpuusage + el[1].to_s + ","
  end

  @memlist = []
  @memnames = ""
  @memusage = ""

  @top5mem.each do |el|
    @memnames = @memnames + "|" + el[0]
    @memlist << el[0]
    @memusage = @memusage + el[1].to_s + ","
  end
 
  haml :reports
end

get '/linechart' do
  name = params[:name]
  @stats = Stat.all(:name => name,  :order => [:created_at.desc])

  @dpoints = @stats.collect do |el| el.created_at.strftime('"%H:%M"') end
  @dpoints = "|" + @dpoints.join('|')

  @mpoints = @stats.collect do |el| el.mem end
  @mpoints = @mpoints.join(',')
  haml :linechart
end
