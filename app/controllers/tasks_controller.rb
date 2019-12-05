class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    if logged_in?
      #@tasks = Task.order(id: :desc).page(params[:page]).per(5)
      #@tasks = Task.where(user_id: session[:user_id]).order(id: :desc).page(params[:page]).per(5)
      @user = User.find_by(id: session[:user_id])
      @tasks = @user.tasks.order(id: :desc).page(params[:page]).per(5)
    else
      redirect_to login_path
    end
  end

  def show
  end

  def new
      @tasks = Task.new
  end

  def create
      @tasks = current_user.tasks.build(task_params)
      if @tasks.save
        flash[:success] = 'Task が正常に投稿されました'
        redirect_to tasks_url
      else
#        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        flash.now[:danger] = 'Task が投稿されませんでした'
        render :new
      end
  end

  def edit
  end

  def update
    if @tasks.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to tasks_url
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end  
  end

  def destroy
    @tasks.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end    

  def set_task
    @tasks = Task.find(params[:id])
  end
  
  def task_params
    #params.require(:task).permit(:content, :status, :user)
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
