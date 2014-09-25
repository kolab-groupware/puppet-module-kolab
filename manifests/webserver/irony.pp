class kolab::webserver::irony inherits kolab::webserver::common {
    package { "iRony":
        ensure => $kolab::pkg::irony_version
    }

    file { "/etc/iRony/dav.inc.php":
        mode => "640",
        owner => "root",
        group => "apache",
        content => template("kolab/iRony.conf.erb"),
        require => Package["iRony"]
    }

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "caldav.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/caldav.conf.erb"
    }

    @webserver::virtualhost { "carddav.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/carddav.conf.erb"
    }

    @webserver::virtualhost { "webdav.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/webdav.conf.erb"
    }
}
