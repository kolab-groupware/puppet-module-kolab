define kolab::hosteddomain {
    file { "/etc/postfix/ldap/$name/":
        ensure => directory,
        owner => "root",
        group => "root",
        mode => "750",
        noop => false
    }

    file { "/etc/postfix/ldap/$name/local_recipient_maps.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_local_recipient_maps.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/mailenabled_distgroups.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_mailenabled_distgroups.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/mailenabled_dynamic_distgroups.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_mailenabled_dynamic_distgroups.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/mydestination.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_mydestination.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/transport_maps.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_transport_maps.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/virtual_alias_maps_catchall.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_virtual_alias_maps_catchall.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/virtual_alias_maps.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_virtual_alias_maps.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/virtual_alias_maps_mailforwarding.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_virtual_alias_maps_mailforwarding.cf.erb"),
        noop => false
    }

    file { "/etc/postfix/ldap/$name/virtual_alias_maps_sharedfolders.cf":
        owner => "root",
        group => "root",
        mode => "640",
        content => template("kolab/postfix/ldap/domain_virtual_alias_maps_sharedfolders.cf.erb"),
        noop => false
    }
}
