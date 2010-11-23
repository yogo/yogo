module ProjectsHelper
  
  def sites_list(sites)
    # output = 'SAFE!'
    output = sites.map do |site|
      sv = site.sensor_values[-1]
      if !sv.nil?
        site.name + ': ' + sv.timestamp.to_time.strftime("%m/%d/%Y at %I:%M%p, %Z")
      else
        site.name + ': no data'
      end
    end

    return output.join('<br>').html_safe
  end
  
end