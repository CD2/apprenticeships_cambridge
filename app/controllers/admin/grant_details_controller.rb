class Admin::GrantDetailsController < AdminController
  
  before_action :set_grant_detail, except: [:index, :search]

  def index
    if params[:training_provider_id]
      @training_provider_name = TrainingProvider.find(params[:training_provider_id]).name
      @grant_details = TrainingProvider.find(params[:training_provider_id]).grant_details
    else
      @grant_details = GrantDetail.includes(:user).all
    end
    respond_to do |format|
      format.html
      format.csv { send_data GrantDetail.to_csv, filename: "grant-details-#{Date.today}.csv" }
    end
  end

  def show
  end

  def search
    @q = GrantDetail.ransack(params[:q])
    @grant_details = @q.result(distinct: true)
  end

  def destroy
    @grant_detail.destroy
    redirect_to admin_grant_details_path
  end

  def download_evidence
    file = @grant_detail.grant_review.documents.find(params[:gid]).document.file
    filename = file.filename
    send_file file.file, filename: filename
  end

  def download_pro_forma_invoice
    respond_to do |format|
      format.html { redirect_to [:admin, @grant_detail] }
      format.docx { render docx: 'pro_forma', filename: 'pro_forma.docx' }
    end
  end

  def send_no_training
    AdminMailer.no_training_provider(@grant_detail, site_email).deliver_now if @grant_detail.training_provider.nil?
    redirect_to admin_grant_detail_path @grant_detail
  end


private

  def set_grant_detail
    @grant_detail = GrantDetail.find(params[:id])
  end
end
