class MachinesController < ApplicationController
  def load
    @machine = Machine.new(params[:name])
    render json: @machine
  end
  
  def press_button
    @machine = Machine.new(params[:name])
    @machine.press_button
    render json: @machine
  end
end