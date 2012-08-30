class LinesController < ApplicationController
  # GET /lines
  # GET /lines.json
  def index
    @title = I18n.t('.activerecord.models.line').pluralize
    @lines = Line.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lines }
    end
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
    @title = I18n.t('.activerecord.models.line')
    @line = Line.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/new
  # GET /lines/new.json
  def new
    @title = I18n.t('.activerecord.models.line')
    @line = Line.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/1/edit
  def edit
    @title = I18n.t('.activerecord.models.line')
    @line = Line.find(params[:id])
  end

  # POST /lines
  # POST /lines.json
  def create
    @line = Line.new(params[:line])

    respond_to do |format|
      if @line.save
        format.html { redirect_to @line, notice: t('.activerecord.models.line').capitalize + t('.notice.a_successfully_created') }
        format.json { render json: @line, status: :created, location: @line }
      else
        format.html { render action: "new" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lines/1
  # PUT /lines/1.json
  def update
    @line = Line.find(params[:id])

    respond_to do |format|
      if @line.update_attributes(params[:line])
        format.html { redirect_to @line, notice: t('.activerecord.models.line').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    @line = Line.find(params[:id])
    @line.destroy

    respond_to do |format|
      format.html { redirect_to lines_url, notice: t('.activerecord.models.line').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
