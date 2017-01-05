require 'test_helper'

class EmailRemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
  end

  test "should get index" do
    get email_reminders_url
    assert_response :success
  end

  test "should get new" do
    get new_email_reminder_url
    assert_response :success
  end

  test "create" do
    assert_difference('EmailReminder.count') do
      post email_reminders_url, params: {email_reminder: attrs}
      puts flash.inspect
    end

    assert_redirected_to email_reminder_url(EmailReminder.last)
  end

  test "should show email_reminder" do
    get email_reminder_url(@email_reminder)
    assert_response :success
  end

  test "should get edit" do
    get edit_email_reminder_url(@email_reminder)
    assert_response :success
  end

  test "should update email_reminder" do
    patch email_reminder_url(@email_reminder), params: {email_reminder: {chronic: @email_reminder.chronic, description: @email_reminder.description, title: @email_reminder.title}}
    assert_redirected_to email_reminder_url(@email_reminder)
  end

  test "should destroy email_reminder" do
    assert_difference('EmailReminder.count', -1) do
      delete email_reminder_url(@email_reminder)
    end

    assert_redirected_to email_reminders_url
  end

  def attrs
    {chronic: 'in 1 sec',
     description: 'email reminder description',
     title: 'email reminder title'
    }
  end

end
