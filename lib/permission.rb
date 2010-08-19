module Permission

  def basic_permissions
    [:create, :retrieve, :update, :delete]
  end

  def extended_permissions
    []
  end

  def permissions
    [basic_permissions, extended_permissions].flatten.map { |item| item.to_s }
  end

  def to_permissions
    permissions.map { |perm| "#{perm}_#{name.underscore}" }
  end
end