class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :started, :complete]

  respond_to :html, :json

  def index
    chain = []
    chain << [:show_at, params[:show_at]]
    chain << [:completed_at, params[:completed_at]]
    chain << [:or_categories, params[:or_categories]]
    chain << [:and_tags, params[:and_tags]]
    chain << [:for_user, params[:for_user]]
    @todos = Todo
    chain.each do |scope, params|
      @todos = @todos.send(scope, params)
    end

    #short cut until device is implemented
    @todos = Todo.all if chain.blank?

    respond_with(@todos)
  rescue =>e
    @todos = Todo.all
    flash.now[:error] = "#{e.message}"
  end

  def show
    respond_with(@todo)
  end

  def new
    @todo = Todo.new
    respond_with(@todo)
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.category_id.nil?
      category = Todo.order(:updated_at).last.try(category)
      @todo.category = category
    end

    if @todo.show_at_chronic.present?
      @todo.show_at = Chronic.parse(@todo.show_at_chronic)
      if @todo.show_at.nil?
        raise ChronicError.new(@todo.show_at_chronic)
      end
    end

    @todo.build_tags(params[:todo][:tags])

    respond_to do |format|

      if @todo.save
        format.html { redirect_to todos_path, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  rescue ChronicError => e
    format.html { render :new }
    format.json { render json: e, status: :unprocessable_entity }
  end

  def update
    @todo.update(todo_params)
    @todo.build_tags(params[:todo][:tags])
    respond_with(@todo)
  end

  def destroy
    @todo.destroy
    respond_with(@todo)
  end

  def started
    set_with_time_current(:started_at)
  end

  def complete
    set_with_time_current(:completed_at)
  end

  private
  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :show_at, :show_at_chronic, :started_at, :completed_at, :category_id)
  end

  def set_with_time_current(field)
    if field.nil?
      puts 'nil'
    end
    if @todo.update(field => Time.current)
      flash[:notice] = 'Todo started_at set'
    else
      flash[:error] = @todo.errors.full_messages
    end
    redirect_to action: 'index'

  end
end
