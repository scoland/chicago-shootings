class VictimsController < ApplicationController

  def index
  	@victims = Victim.all
  	@victim_days = @victims.group_by { |victim| victim.date }
  end

end