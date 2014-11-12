class kolab::imap inherits kolab::common {
    @exec { "_usr_lib_cyrus-imapd_mkimap":
        command => "/usr/lib/cyrus-imapd/mkimap",
        user => "cyrus",
        refreshonly => true,
        require => [
                File["/etc/imapd.conf"],
                Package["cyrus-imapd"]
            ]
    }

    @file { "/etc/cyrus.conf":
        require => Package["cyrus-imapd"],
        notify => Service["cyrus-imapd"],
        owner => "root",
        group => "mail",
        mode => "640"
    }

    file { "/etc/imapd.annotations.conf":
        source => "puppet://$server/private/$environment/files/cyrus/imapd.annotations.conf",
        require => Package["cyrus-imapd"],
        notify => Service["cyrus-imapd"],
        owner => "root",
        group => "root",
        mode => "644"
    }

    @file { "/etc/imapd.conf":
        require => Package["cyrus-imapd"],
        notify => [
                Exec["_usr_lib_cyrus-imapd_mkimap"],
                Service["cyrus-imapd"]
            ],
        owner => "root",
        group => "mail",
        mode => "640"
    }

    file { "/etc/security/limits.d/50-cyrus.conf":
        source => [
                "puppet://$server/private/$environment/files/cyrus/cyrus.limits.$hostname",
                "puppet://$server/private/$environment/files/cyrus/cyrus.limits"
            ],
        ensure => "file",
        owner  => "root",
        group  => "root",
        mode   => "644"
    }

    @file { "/etc/sysconfig/cyrus-imapd":
        source => "puppet://$server/private/$environment/files/cyrus/cyrus-imapd.sysconfig",
        require => Package["cyrus-imapd"],
        notify => Service["cyrus-imapd"],
        owner => "root",
        group => "root",
        mode => "640"
    }

    munin::plugin { "cyrus-imapd":
        enable => true,
        source => true,
        conf => [
                "puppet://$server/private/$environment/munin/plugin-conf.d/cyrus-imapd.$hostname",
                "puppet://$server/private/$environment/munin/plugin-conf.d/cyrus-imapd"
            ],
        conf_name => "cyrus-imapd"
    }

    munin::plugin { [
            "cyrus-imapd_mbox",
            "cyrus-imapd_logins"
        ]:
        enable => true,
        source => true,
        plugin_name => "cyrus-imapd_",
        conf => [
                "puppet://$server/private/$environment/munin/plugin-conf.d/cyrus-imapd.$hostname",
                "puppet://$server/private/$environment/munin/plugin-conf.d/cyrus-imapd"
            ],
        conf_name => "cyrus-imapd"
    }

    package { "cyrus-imapd":
        ensure => getvar("kolab::pkg::cyrus_imapd_version")
    }

    @service { "cyrus-imapd":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => [
                Exec["_usr_lib_cyrus-imapd_mkimap"],
                File["/etc/cyrus.conf"],
                File["/etc/imapd.conf"],
                Package["cyrus-imapd"]
            ]
    }

    if (!defined(User["cyrus"])) {
        @user { "cyrus":
            ensure => present,
            uid => 76,
            gid => 12,
            comment => "Cyrus IMAP Server",
            shell => "/sbin/nologin",
            home => "/var/lib/imap"
        }
    }

    realize(User["cyrus"])
}
