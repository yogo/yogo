class NavigationController < ApplicationController
  unloadable
  #helper :application
  
  def index
    @nav_models = NavModel.all
  end
  
  def update
    @nav_model = NavModel.get(params['id'])
    @nav_model.update(:display       => params['nav_model']['display'],
                      :display_name  => params['nav_model']['display_name'],
                      :model_id      => params['nav_model']['model_id']
                      #:name          => params['nav_model']['name']
                      #:display_count => params['nav_model']['display_count']
                      )
    params['nav_model']['attributes'].each_pair do |attr_name, attr_settings|
      current_attribute = nil
      # finds the correct attribute to modify
      @nav_model.nav_attributes.each do |nav_attribute|
        if nav_attribute.name == attr_name
          current_attribute = nav_attribute
        end
      end
      values = attr_settings.delete("values")
      current_attribute.update(attr_settings)
      values.each_pair do |x, y|
        db_val = NavDatabaseValue.create
        dp_val = NavDisplayValue.create
        if x.include?('hard')
          db_val.value = y['database_value']
          dp_val.value = y['display_value']
        elsif x.include?('soft')
          db_val.value = "#{y['min_value']}..#{y['max_value']}"
          dp_val.value = y['display_value']
        end
        dp_val.nav_database_value = db_val
        current_attribute.nav_display_values << dp_val
        current_attribute.save
      end unless values.nil?
    end
    params['nav_model']['remove'].each_pair do |attribute, display|
      display.each_key do |display_id|
        NavAttribute.get(attribute).nav_display_values.first(:id => display_id).destroy
      end
    end unless params['nav_model']['remove'].nil?
    params['nav_model']['attributes_to_delete'].each_key do |attr_id|
      @nav_model.nav_attributes.get(attr_id).destroy
    end unless params['nav_model']['attributes_to_delete'].nil?
    redirect_to '/navigation'
  end

  def edit
    @nav_model = NavModel.get(params[:id])
  end

  def add_value
    session[:counter] ||= 0
    session[:counter] +=1
    if params[:value_type] == "true"
      render :partial => 'soft_value', :locals => {:counter => session[:counter]}
    elsif params[:value_type] == "false"
      render :partial => 'hard_value', :locals => {:counter => session[:counter]}
    end
  end
  
end