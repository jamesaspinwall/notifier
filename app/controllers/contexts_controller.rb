class ContextsController < ApplicationController
  before_action :set_context, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contexts = Context.all
    respond_with(@contexts)
  end

  def show
    respond_with(@context)
  end

  def new
    @context = Context.new
    respond_with(@context)
  end

  def edit
  end

  def create
    @context = Context.new(context_params)
    @context.save
    respond_with(@context)
  end

  def update
    @context.update(context_params)
    respond_with(@context)
  end

  def destroy
    @context.destroy
    respond_with(@context)
  end

  private
    def set_context
      @context = Context.find(params[:id])
    end

    def context_params
      params.require(:context).permit(:name)
    end
end
