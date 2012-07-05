class MachinesController < ApplicationController
  def load
    @machine = Machine.new
    render json: @machine
  end
  
  def press_button
    @machine = Machine.new
    @machine.press_button
    render json: @machine
  end
end