class MachinesController < ApplicationController
  def load
    @machine = Machine.new
    render json: @machine
  end
end