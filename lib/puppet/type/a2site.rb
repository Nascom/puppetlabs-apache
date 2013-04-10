Puppet::Type.newtype(:a2site) do
    @doc = "Manage Apache 2 vhosts"

    ensurable

    newparam(:name) do
       desc "The name of the vhost to be managed"

       isnamevar

    end

    newparam(:priority) do
      desc "The priority of the vhost to be loaded"

      defaultto { "25" }
    end

    autorequire(:package) { catalog.resource(:package, 'httpd')}

end
