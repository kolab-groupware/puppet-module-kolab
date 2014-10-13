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

    realize(
            Webserver::Module::Enable["mod_authz_core"],
            Webserver::Module::Enable["mod_slotmem_shm"],
            Webserver::Module::Enable["mod_socache_shmcb"],
            Webserver::Module::Enable["mod_ssl"],
            Webserver::Module::Enable["mod_unixd"],
            Webserver::Module::Enable["php"],
            Webserver::Virtualhost["freebusy.${vhost_domain}"]
        )
}
