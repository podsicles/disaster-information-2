class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  require 'csv'

  def index
    @posts = Post.includes(:categories, :user, :region, :province, :city, :barangay).page(params[:page]).per(5)
    regions = Address::Region.all.includes(provinces: { cities: :barangays })
    respond_to do |format|
      format.html
      format.xml { render xml: @posts.as_json }
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << ['Region', 'Province', 'City', 'Barangay']
          regions.each do |region|
            region.provinces.each do |province|
              province.cities.each do |city|
                city.barangays.each do |barangay|
                  csv << [region.name, province.name, city.name, barangay.name]
                end
              end
            end
          end
        end
        send_data csv_string, filename: "philippine_regions_provinces_cities_barangays.csv"
      }
    end
  end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
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