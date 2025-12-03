class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :download_contract ]

  def index
    logger.info "current_user = #{current_user}"
    # @products = Product.includes(:rich_text_description, :counter).all
    @products = Product.includes(:counter).all
  end

  def show
    ActiveRecord.after_all_transactions_commit do
      ProductWasViewedJob.perform_later @product, current_user
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @product = Product.find(params[:id])
  end

  def update
    # @product = Product.find(params[:id])
    Product.transaction do
      if @product.update(product_params)
        redirect_to @product
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  def download_contract
    unless @product.contract.attached?
      head :not_found and return
    end
    contract_blob = @product.contract.blob
    data = contract_blob.download
    send_data data,
              filename: contract_blob.filename.to_s,
              type: contract_blob.content_type,
              disposition: "attachment"
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.expect(product: [ :name, :description, :inventory_count, :contract ])
  end
end
