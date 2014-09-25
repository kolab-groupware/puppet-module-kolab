class kolab::webserver::freebusy inherits kolab::webserver::common {
    package { "kolab-freebusy":
        ensure => $kolab::pkg::kolab_freebusy_version
    }

    file { "/etc/kolab-freebusy/config.ini":
        mode => "640",
        owner => "root",
        group => "apache",
        content => template("kolab/freebusy.conf.erb"),
        require => Package["kolab-freebusy"]
    }

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "freebusy.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/freebusy.conf.erb"
    }
}
