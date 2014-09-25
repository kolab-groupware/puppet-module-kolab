class kolab::nagios {
    include nagios::client::passive

    file { "/etc/nagios/plugins.ini":
        mode => "640",
        owner => "root",
        group => "root",
        noop => false,
        content => template("/var/lib/puppet/files/$domain/nagios/client/plugins.ini.erb")
    }

    @nagios::plugin { "check_saslauthd":
        enable => true
    }

    @nagios::plugin { "check_memcached":
        enable => true,
        require => Package["perl-Cache-Memcached"]
    }

    @package { "perl-Cache-Memcached":
        ensure => installed,
        noop => false
    }

    package { [
            "perl-Nagios-Plugin"
        ]:
        ensure => installed,
        noop => false
    }
}
