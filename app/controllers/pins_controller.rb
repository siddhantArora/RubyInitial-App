class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]

  # now user has to sign in ,otherwise they cant create a new pin , since there are too many in "only"
  #so better use "except"

  #before_action :authenticate_user!,only:[:new,:edit,:create]


    #since we can access and edit the pin which doesnot belong to the current log in user
    #We ahve to stop the access of the  edit of that pin
  before_action :correct_user,only:[:edit ,:update,:destroy]

  #use has to authenicate on all pages excet the index and user
  before_action :authenticate_user!,except:[:index,:show]

  respond_to :html

  def index
    @pins = Pin.all
    respond_with(@pins)
  end

  def show
    respond_with(@pin)
  end

  def new
   # @pin = Pin.new
   @pin = current_user.pins.build
    respond_with(@pin)
  end

  def edit
  end

  def create
    #@pin = Pin.new(pin_params)
    @pin = current_user.pins.build(pin_params)
    @pin.save
    respond_with(@pin)
  end

  def update
    @pin.update(pin_params)
    respond_with(@pin)
  end

  def destroy
    @pin.destroy
    respond_with(@pin)
  end

  private
    def set_pin
      @pin = Pin.find(params[:id])
    end

    #since we can access and edit the pin which doesnot belong to the current log in user
    #We ahve to stop the access of the  edit of that pin

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this pin "if@pin.nil?
    end

    def pin_params
      params.require(:pin).permit(:description)
    end
end
