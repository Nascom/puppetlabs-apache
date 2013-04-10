Puppet::Type.type(:a2site).provide(:a2site) do
    desc "Manage Apache 2 vhosts on Debian and Ubuntu"

    optional_commands :encmd => "a2ensite"
    optional_commands :discmd => "a2dissite"

    confine :osfamily => :debian
    defaultfor :operatingsystem => [:debian, :ubuntu]

    def create
        encmd resource[:priority] + "-" + resource[:name]
    end

    def destroy
        discmd resource[:priority] + "-" + resource[:name]
    end

    def exists?
        site= "/etc/apache2/sites-enabled/" + resource[:priority] + "-" + resource[:name]
        File.exists?(site)
    end
end
