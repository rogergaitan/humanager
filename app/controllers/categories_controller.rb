class CategoriesController < ApplicationController
  
  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  respond_to :json, :html
  
  # GET /categories
  # GET /categories.json,
  def index
    @title = t('.activerecord.models.category').capitalize.pluralize
    @categories = Category.all
    @categories = Category.paginate(:page => params[:page], :per_page => 10)
    respond_with @categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @title = t('.activerecord.models.category').capitalize
    @category = Category.find(params[:id])
    respond_with @category
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @title = t('.activerecord.models.category').capitalize
    @category = Category.new
    respond_with @category
  end

  # GET /categories/1/edit
  def edit
    @title = t('.activerecord.models.category').capitalize
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  # Create and *Show* or Create and *Continue*
  def create
    @title = t('.activerecord.models.category').capitalize
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        if params['continue']
          format.html { redirect_to new_category_path, notice: t('.activerecord.models.category').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @category, status: :created, location: @category }
        else
          format.html { redirect_to @category, notice: t('.activerecord.models.category').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @category, status: :created, location: @category }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: t('.activerecord.models.category').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: t('.activerecord.models.category').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  # FETCH /lines/categories
  # Get All categories including just the id and the name. 
  def fetch
    respond_with Category.fetch
  end

  # DELETE "Category.all" key from cache
  def clean_cache
    Category.clean_cache
  end

end
