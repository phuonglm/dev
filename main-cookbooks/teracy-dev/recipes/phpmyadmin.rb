if node['teracy-dev']['phpmyadmin']['enabled']
	node.override['phpmyadmin']['home'] = node['dev']['phpmyadmin']['install_dir']
	node.override['phpmyadmin']['fpm'] = false
	include_recipe 'phpmyadmin::default'

	if node['teracy-dev']['apache']['enabled']
		cookbook_file '/etc/apache2/sites-available/phpMyAdmin.conf' do
		    mode 0644
		    owner 'root'
		    group 'root'
		    source "config/#{node['env']}/etc/apache2/sites-available/phpMyAdmin.conf"
		end

		link "/etc/apache2/sites-enabled/phpMyAdmin.conf" do
		    to "/etc/apache2/sites-available/phpMyAdmin.conf"
		end
	end

	if node['teracy-dev']['nginx']['enabled']
		cookbook_file '/etc/apache2/sites-available/phpMyAdmin.conf' do
		    mode 0644
		    owner 'root'
		    group 'root'
		    source "config/#{node['env']}/etc/apache2/sites-available/phpMyAdmin.conf"
		end

		link "/etc/apache2/sites-enabled/phpMyAdmin.conf" do
		    to "/etc/apache2/sites-available/phpMyAdmin.conf"
		end
	end
end