class CampaignMenuCell < Cell::Rails

  def display
    @current_user = @opts[:current_user]
    @campaigns = []
    render
  end
end
