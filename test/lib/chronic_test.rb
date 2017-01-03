class ChronicTest < Minitest::Test

  def test_scheduled_task
    a=8
    proc = Proc.new { a=44 }
    Task.schedule(Time.current + 0.3, proc)
    sleep 0.4
    assert_equal 44, a
  end

  def test_cancel_scheduled_task
    a=8
    proc = Proc.new { a=44 }
    Task.schedule(Time.current + 0.3, proc)
    Task.current.timer.cancel
    sleep 0.7
    assert_equal 8, a
  end

  def test_cancel_then_schedule_new
    a=8
    proc1 = Proc.new { a=44 }
    proc2 = Proc.new { a=66 }
    Task.schedule(Time.current + 0.3, proc1)
    Task.schedule(Time.current + 0.2, proc2)
    sleep 0.4
    assert_equal 66, a
  end
end
