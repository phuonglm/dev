if node['teracy-dev']['samba']['enabled']
    include_recipe 'samba::server'
end
