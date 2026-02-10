class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    # 修正後: ログイン中のユーザーのアイテムだけ取得
    @items = current_user.items.order(created_at: :desc)
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.jsondef create
  def create
    # 修正後: ログイン中のユーザーに紐付けて作成（user_idが自動で入る）
    @item = current_user.items.build(item_params)

    respond_to do |format|
      if @item.save
        # 作成時に価格取得を実行
        @item.refresh_market_price 
        
        format.html { redirect_to item_url(@item), notice: "アイテムを登録しました！" }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, notice: "Item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      # 自分の持ち物から探す
      @item = current_user.items.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      # 画像（:image）を受け取れるようにする
      params.require(:item).permit(:name, :purchase_price, :current_market_price, :image)
    end
end