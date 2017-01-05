class EmailRemindersController < ApplicationController
  before_action :set_email_reminder, only: [:show, :edit, :update, :destroy]

  # GET /email_reminders
  # GET /email_reminders.json
  def index
    @email_reminders = EmailReminder.all
  end

  # GET /email_reminders/1
  # GET /email_reminders/1.json
  def show
  end

  # GET /email_reminders/new
  def new
    @email_reminder = EmailReminder.new
  end

  # GET /email_reminders/1/edit
  def edit
  end

  # POST /email_reminders
  # POST /email_reminders.json
  def create
    @email_reminder = EmailReminder.new(email_reminder_params)

    respond_to do |format|
      if @email_reminder.save
        format.html { redirect_to @email_reminder, notice: 'Email reminder was successfully created.' }
        format.json { render :show, status: :created, location: @email_reminder }
      else
        format.html { render :new }
        format.json { render json: @email_reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_reminders/1
  # PATCH/PUT /email_reminders/1.json
  def update
    respond_to do |format|
      if @email_reminder.update(email_reminder_params)
        format.html { redirect_to @email_reminder, notice: 'Email reminder was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_reminder }
      else
        format.html { render :edit }
        format.json { render json: @email_reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_reminders/1
  # DELETE /email_reminders/1.json
  def destroy
    @email_reminder.destroy
    respond_to do |format|
      format.html { redirect_to email_reminders_url, notice: 'Email reminder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_reminder
      @email_reminder = EmailReminder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_reminder_params
      params.require(:email_reminder).permit(:chronic, :title, :description)
    end
end
