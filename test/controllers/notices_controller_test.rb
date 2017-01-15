require 'test_helper'

class NoticesControllerTest < ActionDispatch::IntegrationTest

  # HAPPY PATH

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
      post notices_url, params: {notice: notice_attrs}
    end
    assert_redirected_to notice_url(Notice.last)
  end

  test "should show notice" do
    notice = Notice.create(notice_attrs)
    get notice_url(notice)
    assert_response :success
  end

  test "should get edit" do
    notice = Notice.create(notice_attrs)
    get edit_notice_url(notice)
    assert_response :success
  end

  test "should update notice" do
    notice = Notice.create(notice_attrs)
    patch notice_url(notice), params: {notice: notice_attrs}
    assert_redirected_to notice_url(notice)
  end

  test "should destroy notice" do
    notice = Notice.create(notice_attrs)
    assert_difference('Notice.count', -1) do
      delete notice_url(notice.id)
      refute_empty flash[:notice]
    end
    assert_redirected_to notices_url
  end

  # RECORD NOT FOUND

  test "should not destroy NOT FOULD notice" do
    assert_difference('Notice.count', 0) do
      delete notice_url('abc')
      refute_empty flash[:error]
    end
    assert_redirected_to notices_url
  end

  private

end
