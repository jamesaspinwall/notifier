require 'test_helper'

class TodoFlowTest < Capybara::Rails::TestCase


  test 'ISNECUD' do
    # require 'spy'
    # spy = Spy.on(Todo, :show_at)
    # spy.before {
    #   puts self
    #   puts '==> SHOW_AT'
    # }
    create_todos
    visit todos_path(show_at: 'tomorrow')

    assert page.has_content? 'title field'
    assert true
  end

  test 'create new todo with show_at_chronic YESTERDAY' do
    visit todos_path
    click_on 'New Todo'
    attrs = todo_attrs(show_at_chronic: 'yesterday')
    fill_form(attrs)
    click_on 'Create Todo'

    assert_equal 1, Todo.count
    assert_equal 1, Todo.show_at.count

    exp = %r{<td>(.*?)</td>\n        <td></td>\n        <td><a href="(.*?)">Show</a>}
    page.body.scan(exp).each do |title, url|
      assert_equal title, attrs[:title]
      assert_equal todo_path(1), url
    end
    assert_current_path todos_path
  end

  test 'create new todo with tomorrow show_at' do
    visit todos_path
    click_on 'New Todo'
    attrs = todo_attrs(show_at_chronic: 'tomorrow')
    fill_form(attrs)
    click_on 'Create Todo'

    assert_equal 1, Todo.count
    assert_equal 0, Todo.show_at.count
  end

  private

  def create_todos
    Todo.create(todo_attrs)
  end

  teardown do
    #Spy.restore(:all)
  end

  def fill_form(attrs = {})
    fill_in 'Title', with: attrs[:title]
    fill_in 'Description', with: attrs[:description]
    fill_in 'Show at chronic', with: attrs[:show_at_chronic]
  end

end

