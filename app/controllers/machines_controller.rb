class MachinesController < ApplicationController
  def load
    @machine = Machine.new(params[:name])
    render json: @machine.to_hash.slice(:reels, :lines_quantity)
  end
  
  def press_button
    @machine = Machine.new(params[:name])
    @machine.press_button
    render json: @machine.to_hash.slice(:result, :win)
  end
end