class PrototypesController < ApplicationController

  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user)
  end
  
  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else 
      render :new
    end
  end

  def show
   
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    # ＜ログインしているとき別のアカウントで投稿したツイートの編集画面のURLを直接打てば
    # 遷移してしまう問題を以下の記述で解決している＞
    if current_user.id != @prototype.user_id
      redirect_to root_path
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    if  prototype.update(prototype_params)
      redirect_to root_path
    else 
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    # require(:prototype) は、Prototype.new のPrototype,  permitは_formのカラム,  mergeはツイートした人の情報を追加している
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end



end
