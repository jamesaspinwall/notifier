class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :started, :complete]

  respond_to :html, :json

  def index
    chain = []
    chain << [:show_at, params[:show_at]] if params[:show_at].present?
    chain << [:completed, params[:completed]] if params[:completed].present?
    chain << [:or_categories_by_names, params[:categories]] if params[:categories].present?
    chain << [:and_tags, params[:tags]] if params[:tags].present?
    chain.map do |scope, params|
      @todos = Todo.send(scope, params)
    end

    # @todos = if params[:all].present?
    #            Todo.all
    #          elsif params[:completed].present?
    #            Todo.completed
    #          else
    #            Todo.active.showable
    #          end
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
      @todo.category = Todo.order(:updated_at).last.category
    end

    if start_at_chronic.present?
      @todo.start_at = Chronic.parse(@todo.start_at_chronic)
      if @todo.start_at.nil?
        raise ChronicError.new(@todo.start_at_chronic)
      end
    end

    @todo.build_tags(params[:todo][:tags])

    respond_to do |format|

      if @todo.save
        format.html { redirect_to todos_path, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
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
    set_with_time_current(:complete_at)
  end

  private
  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :show_at, :show_at_chronic, :started_at, :complete_at, :category_id)
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
