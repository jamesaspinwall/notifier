class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :complete]

  respond_to :html, :json

  def index
    @todos = params[:all].present? ? Todo.all : Todo.active.showable
    respond_with(@todos)
  end

  def show
    category = Category.all
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
      @todo.category = Todo.order(:updated_at).last.category
    end

    @todo.build_tags(params[:todo][:tags])

    if @todo.save
      format.html { redirect_to todos_path, notice: 'Person was successfully created.' }
      format.json { render :show, status: :created, location: @person }
    else
      format.html { render :new }
      format.json { render json: @person.errors, status: :unprocessable_entity }
    end
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
    if @todo.update(started_at: Time.current)
      flash[:notice] = 'Todo started_at set'
    else
      flash[:error] = @todo.errors.full_messages
    end
    redirect_to action: 'index'
  end

  def complete
    if @todo.update(complete_at: Time.current)
      flash[:notice] = 'Todo completed'
    else
      flash[:error] = @todo.errors.full_messages
    end
    redirect_to action: 'index'
  end

  private
  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :show_at, :started_at, :complete_at, :category_id)
  end
end
