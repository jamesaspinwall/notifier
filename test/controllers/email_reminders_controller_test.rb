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
    skip
    assert_difference('EmailReminder.count') do
      post email_reminders_url, params: {email_reminder: email_reminder_attrs}
      puts flash.inspect
      sleep 2
    end

    assert_redirected_to email_reminder_url(EmailReminder.last)
  end

  test "should show email_reminder" do
    id = EmailReminder.create(email_reminder_attrs).id
    get email_reminder_url(id)
    assert_response :success
  end

  test "should get edit" do
    id = EmailReminder.create(email_reminder_attrs).id
    get edit_email_reminder_url(id)
    assert_response :success
  end

  test "should update email_reminder" do
    id = EmailReminder.create(email_reminder_attrs).id
    title = 'anything you want'
    patch email_reminder_url(id), params: {email_reminder: {title: title}}
    assert_redirected_to email_reminder_url(id)
    assert_equal title, EmailReminder.find(id).title
  end

  test "should destroy email_reminder" do

    # DOES IT REMOVE THE TIMED TASK???

    id = EmailReminder.create(email_reminder_attrs).id
    assert_difference('EmailReminder.count', -1) do
      delete email_reminder_url(id)
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
