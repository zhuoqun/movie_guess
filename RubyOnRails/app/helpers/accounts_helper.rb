module AccountsHelper
  def settings_menus
    url_prefix = '/accounts/settings'
    #[{:id => 'setting_profile', :url => "#{url_prefix}/profile", :name => t(:setting_profile)}, {:id => 'setting_password', :url => "#{url_prefix}/password", :name => t(:setting_password)}, {:id => 'setting_avatar', :url => "#{url_prefix}/avatar", :name => t(:setting_avatar)}, {:id => 'setting_domain', :url => "#{url_prefix}/domain", :name => t(:setting_domain)}, {:id => 'setting_mail', :url => "#{url_prefix}/mail", :name => t(:setting_mail)}]
    [{:id => 'setting_profile', :url => "#{url_prefix}/profile", :name => t(:setting_profile)}, {:id => 'setting_password', :url => "#{url_prefix}/password", :name => t(:setting_password)}, {:id => 'setting_avatar', :url => "#{url_prefix}/avatar", :name => t(:setting_avatar)}, {:id => 'setting_domain', :url => "#{url_prefix}/domain", :name => t(:setting_domain)}]
  end
end
