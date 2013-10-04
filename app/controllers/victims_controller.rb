class VictimsController < ApplicationController

  def index
  	@victims = Victim.all
  end

end