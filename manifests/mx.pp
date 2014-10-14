class kolab::mx inherits kolab::common {
    class common inherits kolab::mx {
        class { 'postfix::template':
            main_cf => "kolab/postfix/main.cf.erb",
            master_cf => "kolab/postfix/master.cf.erb"
        }

        exec { "openssl_gendh__etc_postfix_dh1024_pem":
            command => "openssl gendh -out /etc/postfix/dh_1024.pem -2 1024",
            creates => "/etc/postfix/dh_1024.pem"
        }

        exec { "openssl_gendh__etc_postfix_dh512_pem":
            command => "openssl gendh -out /etc/postfix/dh_512.pem -2 512",
            creates => "/etc/postfix/dh_512.pem"
        }

        exec { "postmap__etc_postfix_transport":
            command => "postmap /etc/postfix/transport",
            refreshonly => true
        }

        @file { "/etc/postfix/transport":
            owner => "root",
            group => "root",
            mode => "640",
            content => template("kolab/postfix/transport.erb"),
            notify => Exec["postmap__etc_postfix_transport"]
        }
    }

    class amavisd inherits kolab::common {
        file { "/etc/amavisd/amavisd.conf":
            owner => "root",
            group => "root",
            mode => "644",
            content => template("kolab/amavisd/amavisd.conf.erb"),
            require => Package["amavisd-new"],
            notify => Service["amavisd"]
        }

        file { "/etc/clamd.d/amavisd.conf":
            owner => "root",
            group => "root",
            mode => "644",
            source => [
                    "puppet://$server/private/$environment/kolab/amavisd/clamd.conf.$hostname",
                    "puppet://$server/private/$environment/kolab/amavisd/clamd.conf",
                    "puppet://$server/files/kolab/amavisd/clamd.conf.$hostname",
                    "puppet://$server/files/kolab/amavisd/clamd.conf",
                    "puppet://$server/modules/kolab/amavisd/clamd.conf.$hostname",
                    "puppet://$server/modules/kolab/amavisd/clamd.conf"
                ],
            require => Package["clamd"],
            notify => Service["clamd.amavisd"]
        }

        file { "/etc/sysconfig/clamd":
            owner => "root",
            group => "root",
            mode => "644",
            source => [
                    "puppet://$server/private/$environment/kolab/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/private/$environment/kolab/amavisd/clamd.sysconfig",
                    "puppet://$server/files/kolab/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/files/kolab/amavisd/clamd.sysconfig",
                    "puppet://$server/modules/kolab/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/modules/kolab/amavisd/clamd.sysconfig"
                ],
            require => Package["clamd"],
            notify => Service["clamd.amavisd"]
        }

        package { [
                "amavisd-new",
                "clamd"
            ]:
            ensure => installed
        }

        service { "amavisd":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/amavisd/amavisd.conf"],
                    Package["amavisd-new"]
                ]
        }

        service { "clamd.amavisd":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/clamd.d/amavisd.conf"],
                    File["/etc/sysconfig/clamd"],
                    Package["clamd"]
                ]
        }
    }

    class backend inherits kolab::mx::ldap {
        realize(File["/etc/postfix/transport"])
    }

    class external inherits kolab::mx::common {
        realize(File["/etc/postfix/transport"])

        class inbound inherits kolab::mx::external {
            # For anti-spam, anti-virus
            include kolab::mx::amavisd
        }

        class outbound inherits kolab::mx::external {
            # For DKIM
            include kolab::mx::amavisd
        }
    }

    class internal inherits kolab::mx::ldap {
        realize(
                File["/etc/postfix/transport"],
                Package["kolab-saslauthd"],
                Package["postfix-kolab"],
                Service["kolab-saslauthd"]
            )

        realize(Nagios::Plugin['check_saslauthd'])

        exec { "postmap__etc_postfix_header_checks_inbound":
            command => "postmap /etc/postfix/header_checks.inbound",
            refreshonly => true
        }

        exec { "postmap__etc_postfix_header_checks_internal":
            command => "postmap /etc/postfix/header_checks.internal",
            refreshonly => true
        }

        exec { "postmap__etc_postfix_header_checks_submission":
            command => "postmap /etc/postfix/header_checks.submission",
            refreshonly => true
        }

        file { "/etc/postfix/header_checks.inbound":
            source => [
                    "puppet://$server/private/$environment/postfix/header_checks.inbound",
                    "puppet://$server/modules/kolab/postfix/header_checks.inbound"
                ],
            notify => Exec["postmap__etc_postfix_header_checks_inbound"]
        }

        file { "/etc/postfix/header_checks.internal":
            source => [
                    "puppet://$server/private/$environment/postfix/header_checks.internal",
                    "puppet://$server/modules/kolab/postfix/header_checks.internal"
                ],
            notify => Exec["postmap__etc_postfix_header_checks_internal"]
        }

        file { "/etc/postfix/header_checks.submission":
            source => [
                    "puppet://$server/private/$environment/postfix/header_checks.submission",
                    "puppet://$server/modules/kolab/postfix/header_checks.submission"
                ],
            notify => Exec["postmap__etc_postfix_header_checks_submission"]
        }

        package { "wallace":
            ensure => getvar("kolab::pkg::wallace_version")
        }

        service { "wallace":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/kolab/kolab.conf"],
                    Package["wallace"]
                ]
        }
    }

    class ldap inherits kolab::mx::common {
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

        file { "/etc/postfix/ldap/mydestination.cf":
            owner => "root",
            group => "root",
            mode => 640,
            content => template("kolab/postfix/ldap/mydestination.cf.erb")
        }

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
