class kolab::ldap inherits kolab::common {
    # apply kernel parameters if sysctl.conf file changes.
    exec { "sysctl -p /etc/sysctl.d/389-ds":
        subscribe => File["/etc/sysctl.d/389-ds"],
        refreshonly => true
    }

    # Change file descriptors limits to tune performance
    file { "/etc/security/limits.d/50-389ds.conf":
        source => [
                "puppet://$server/private/$environment/files/389ds/389-ds.limits.$hostname",
                "puppet://$server/private/$environment/files/389ds/389-ds.limits",
                "puppet://$server/files/389ds/389-ds.limits",
                "puppet://$server/modules/kolab/389ds/389-ds.limits"
            ],
        ensure => "file",
        owner  => "root",
        group  => "root",
        mode   => 644
    }

    # Not all RH installations have this directory by default
    file { "/etc/sysctl.d/":
        ensure => "directory",
        owner  => "root",
        group  => "root",
        mode   => 755
    }

    # Supply sysctl file for 389-DS, to tune up performance
    file { "/etc/sysctl.d/389-ds":
        source => [
                "puppet://$server/private/$environment/files/389ds/389-ds.sysctl.$hostname",
                "puppet://$server/private/$environment/files/389ds/389-ds.sysctl",
                "puppet://$server/files/389ds/389-ds.sysctl.$hostname",
                "puppet://$server/files/389ds/389-ds.sysctl",
                "puppet://$server/modules/kolab/389ds/389-ds.sysctl"
            ],
        ensure => "file",
        owner  => "root",
        group  => "root",
        mode   => 644
    }

    file { "/etc/sysconfig/dirsrv":
        source => [
                "puppet://$server/private/$environment/files/389ds/389-ds.sysconfig.$hostname",
                "puppet://$server/private/$environment/files/389ds/389-ds.sysconfig",
                "puppet://$server/files/389ds/389-ds.sysconfig.$hostname",
                "puppet://$server/files/389ds/389-ds.sysconfig",
                "puppet://$server/modules/kolab/389ds/389-ds.sysconfig"
            ],
        ensure => "file",
        owner  => "root",
        group  => "root",
        mode   => 644
    }

    # Specify mutex for 389 DS. THis will fail, since we don't yet know how to get instance name,
    # so we could copy DB_CONFIG file to correct location. For now just copying to config location.
    file { "/etc/dirsrv/DB_CONFIG":
        source => [
                "puppet://$server/private/$environment/files/389ds/389-ds.DB_CONFIG.$hostname",
                "puppet://$server/private/$environment/files/389ds/389-ds.DB_CONFIG",
                "puppet://$server/files/389ds/389-ds.DB_CONFIG.$hostname",
                "puppet://$server/files/389ds/389-ds.DB_CONFIG",
                "puppet://$server/modules/kolab/389ds/389-ds.DB_CONFIG"
            ],
        ensure => "file",
        owner  => "nobody",
        group  => "nobody",
        mode   => 644
    }

    munin::plugin { [
            "bdbstat_lockers",
            "bdbstat_mutex"
        ]:
        enable => true,
        source => true,
        plugin_name => "bdbstat_",
        conf => [
                "puppet://$server/private/$environment/munin/plugin-conf.d/bdbstat.$hostname",
                "puppet://$server/private/$environment/munin/plugin-conf.d/bdbstat",
                "puppet://$server/files/munin/plugin-conf.d/bdbstat.$hostname",
                "puppet://$server/files/munin/plugin-conf.d/bdbstat",
                "puppet://$server/modules/munin/plugin-conf.d/bdbstat",
                "puppet://$server/modules/kolab/munin/plugin-conf.d/bdbstat"
            ],
        conf_name => "bdbstat"
    }

    munin::plugin { [
            "389ds_database",
            "389ds_vlv"
        ]:
        enable => true,
        source => true,
        plugin_name => "389ds_",
        conf => [
                "puppet://$server/private/$environment/munin/plugin-conf.d/389ds.$hostname",
                "puppet://$server/private/$environment/munin/plugin-conf.d/389ds",
                "puppet://$server/files/munin/plugin-conf.d/389ds.$hostname",
                "puppet://$server/files/munin/plugin-conf.d/389ds",
                "puppet://$server/modules/munin/plugin-conf.d/389ds",
                "puppet://$server/modules/kolab/munin/plugin-conf.d/389ds"
            ],
        conf_name => "389ds"
    }

    package { "kolab-ldap":
        ensure => getvar("kolab::pkg::kolab_ldap_version")
    }

    service { "dirsrv":
        ensure => running,
        enable => true,
        require => [
                File["/etc/sysconfig/dirsrv"],
                File["/etc/sysctl.d/389-ds"],
                Package["kolab-ldap"],
            ],
    }
}
