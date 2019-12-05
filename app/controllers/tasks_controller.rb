class TasksController < ApplicationController
  before_action :require_user_logged_in
  #before_action :set_task, only: [:show, :edit, :update, :destroy]
  #correct_userで包括されているため不要↑
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    if logged_in?
      #@tasks = Task.order(id: :desc).page(params[:page]).per(5)
      #@tasks = Task.where(user_id: session[:user_id]).order(id: :desc).page(params[:page]).per(5)
      #丁寧に書くと↑こうなる
      @user = User.find_by(id: session[:user_id])
      @tasks = @user.tasks.order(id: :desc).page(params[:page]).per(5)
    else
      redirect_to login_path
    end
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = Task.new
  end

  def create
      @task = current_user.tasks.build(task_params)
      if @task.save
        flash[:success] = 'Task が正常に投稿されました'
        redirect_to tasks_url
      else
        flash.now[:danger] = 'Task が投稿されませんでした'
        render :new
      end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to tasks_url
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end  
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end    

  #def set_task
  #  @tasks = Task.find(params[:id])
  #end
  #correct_userで包括されているので利用なし
  
  def task_params
    #params.require(:task).permit(:content, :status, :user)
    #buildを使わない場合に、ストロングパラメータにuserを入れる必要あり。
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
