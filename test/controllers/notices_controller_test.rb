require 'test_helper'

class NoticesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notice = notices(:one)
  end

  test "should get index" do
    get notices_url
    assert_response :success
  end

  test "should get new" do
    get new_notice_url
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post notices_url, params: { notice: { cancelled: @notice.cancelled, description: @notice.description, notify_at: @notice.notify_at, notify_chronic: @notice.notify_chronic, repeat: @notice.repeat, sent_at: @notice.sent_at, title: @notice.title } }
    end

    assert_redirected_to notice_url(Notice.last)
  end

  test "should show notice" do
    get notice_url(@notice)
    assert_response :success
  end

  test "should get edit" do
    get edit_notice_url(@notice)
    assert_response :success
  end

  test "should update notice" do
    patch notice_url(@notice), params: { notice: { cancelled: @notice.cancelled, description: @notice.description, notify_at: @notice.notify_at, notify_chronic: @notice.notify_chronic, repeat: @notice.repeat, sent_at: @notice.sent_at, title: @notice.title } }
    assert_redirected_to notice_url(@notice)
  end

  test "should destroy notice" do
    assert_difference('Notice.count', -1) do
      delete notice_url(@notice)
    end

    assert_redirected_to notices_url
  end
end
