class EmailRemindersController < ApplicationController
  before_action :set_email_reminder, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

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
    if @email_reminder.save
      @email_reminder.schedule_task
    end
    respond_with @email_reminder
  end

  # PATCH/PUT /email_reminders/1
  # PATCH/PUT /email_reminders/1.json
  def update
    @email_reminder.update(email_reminder_params)
    respond_with @email_reminder
  end

  # DELETE /email_reminders/1
  # DELETE /email_reminders/1.json
  def destroy
    @email_reminder.destroy
    respond_with @email_reminder
  end

  private
  def set_email_reminder
    @email_reminder = EmailReminder.find(params[:id])
  rescue => e
    flash[:error] = e.message
    redirect_to email_reminders_path
  end

  def email_reminder_params
    params.require(:email_reminder).permit(:chronic, :title, :description)
  end
end
