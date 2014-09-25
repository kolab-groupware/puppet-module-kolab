class kolab::mx inherits kolab::common {
    class common inherits kolab::mx {
        class { 'postfix::template':
            template => "kolab/postfix/main.cf.erb"
        }

        exec { "openssl_gendh__etc_postfix_dh1024_pem":
            command => "openssl gendh -out /etc/postfix/dh_1024.pem -2 1024",
            creates => "/etc/postfix/dh_1024.pem"
        }

        exec { "openssl_gendh__etc_postfix_dh512_pem":
            command => "openssl gendh -out /etc/postfix/dh_512.pem -2 512",
            creates => "/etc/postfix/dh_512.pem"
        }

    }

    class amavisd inherits kolab::common {
    }

    class external inherits kolab::mx::common {
        class inbound inherits kolab::mx::external {
            # For anti-spam, anti-virus
            include kolab::mx::amavisd
        }
        class outbound inherits external {
            # For DKIM
            include kolab::mx::amavisd
        }
    }

    class internal inherits kolab::mx::common {
        realize(Nagios::Plugin['check_saslauthd'])

        file { "/etc/postfix/ldap/":
            ensure => directory,
            owner => "root",
            group => "root",
            recurse => true,
            purge => true,
            force => true,
            require => Package["postfix"],
            notify => Service["postfix"]
        }

        Kolab::Hosteddomain <||>

        file { "/etc/postfix/ldap/hosted_duplet_local_recipient_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_local_recipient_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_mailenabled_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_mailenabled_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_mailenabled_dynamic_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_mailenabled_dynamic_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_mydestination.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_mydestination.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_transport_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_transport_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_catchall.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_virtual_alias_maps_catchall.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_virtual_alias_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_virtual_alias_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_mailforwarding.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_virtual_alias_maps_mailforwarding.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_duplet_virtual_alias_maps_sharedfolders.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_duplet_virtual_alias_maps_sharedfolders.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_local_recipient_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_local_recipient_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_mailenabled_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_mailenabled_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_mailenabled_dynamic_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_mailenabled_dynamic_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_mydestination.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_mydestination.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_transport_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_transport_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_catchall.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_virtual_alias_maps_catchall.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_virtual_alias_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_virtual_alias_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_mailforwarding.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_virtual_alias_maps_mailforwarding.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_triplet_virtual_alias_maps_sharedfolders.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_triplet_virtual_alias_maps_sharedfolders.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_local_recipient_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_local_recipient_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_mailenabled_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_mailenabled_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_mailenabled_dynamic_distgroups.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_mailenabled_dynamic_distgroups.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_mydestination.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_mydestination.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_transport_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_transport_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_virtual_alias_maps_catchall.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_virtual_alias_maps_catchall.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_virtual_alias_maps.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_virtual_alias_maps.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_virtual_alias_maps_mailforwarding.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_virtual_alias_maps_mailforwarding.cf.erb")
        }

        file { "/etc/postfix/ldap/hosted_quadlet_virtual_alias_maps_sharedfolders.cf":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/ldap/hosted_quadlet_virtual_alias_maps_sharedfolders.cf.erb")
        }

    }
}
