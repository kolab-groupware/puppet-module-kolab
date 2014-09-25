class kolab::nagios::server {
    include nagios::server
    include nagios::server::nsca

    file { "/etc/nagios/hostgroups.cfg":
        content => template("kolab/nagios/server/hostgroups.cfg.erb"),
        notify => Service['nagios']
    }

    file { "/etc/nagios/services.cfg":
        content => template("kolab/nagios/server/services.cfg.erb"),
        notify => Service['nagios']
    }

    file { "/etc/nagios/nagios_host.cfg":
        mode => "644"
    }

    nagios::plugin { "check_activesync":
        enable => true
    }

    package { "perl-Net-XMPP":
        ensure => installed
    }
}
