class PostsController < ApplicationController
  require 'csv'
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.includes(:categories, :user, :region, :province, :city, :barangay).page(params[:page]).per(5)
    regions = Address::Region.all.includes(provinces: { cities: :barangays })
    respond_to do |format|
      format.html
      format.xml { render xml: @posts.as_json }
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << ['Region', 'Region Code', 'Province', 'Province Code', 'City', 'City Code' ,'Barangay', 'Barangay Code']
          regions.each do |region|
            region.provinces.each do |province|
              province.cities.each do |city|
                city.barangays.each do |barangay|
                  csv << [region.name, region.code, province.name, province.code, city.name, city.code, barangay.name, barangay.code]
                end
              end
            end
          end
        end
        send_data csv_string, filename: "philippine_regions_provinces_cities_barangays.csv"
      }
    end
  end
  
  def import
    if params[:csv].content_type == 'text/csv'
      CSV.foreach(params[:csv].path) do |row|
        region = Address::Region.find_or_initialize_by(name: row[0], code: row[1])
        region.save
  
        province = Address::Province.find_or_initialize_by(name: row[2], code: row[3], region: region)
        province.save
  
        city = Address::City.find_or_initialize_by(name: row[4], code: row[5], province: province)
        city.save
  
        barangay = Address::Barangay.find_or_initialize_by(name: row[6], code: row[7], city: city)
        barangay.save
      end
      redirect_to root_path, notice: 'CSV file imported successfully.'
    else
      redirect_to root_path, alert: 'Invalid file format. Only CSV files are allowed.'
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.short_url = generate_short_url
    @post.user = current_user
    if Rails.env.development?
        @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
        @post.ip_address = request.remote_ip
    end
    if @post.save
      flash[:notice] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def show_short
    @post = Post.find_by(short_url: params[:short_url])
    if @post
      render :show
    else
      redirect_to root_path, alert: 'Post not found.'
    end
  end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
    session[:return_to] = request.referer
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully'
      redirect_to session.delete(:return_to)
    else
      flash.now[:alert] = 'Post update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    flash[:notice] = 'Post destroyed successfully'
    redirect_to posts_path
  end

  private

  def generate_short_url
    format('%04d', rand(10_000))
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id, :deleted_at, category_ids: [])
  end

  def post_import_params
    params.require(:post_import).permit(:file)
  end
end