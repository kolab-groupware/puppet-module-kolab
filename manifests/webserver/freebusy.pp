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
            Webserver::Module::Enable["mod_alias"],
            Webserver::Module::Enable["mod_authz_core"],
            Webserver::Module::Enable["mod_authz_host"],
            Webserver::Module::Enable["mod_deflate"],
            Webserver::Module::Enable["mod_dir"],
            Webserver::Module::Enable["mod_env"],
            Webserver::Module::Enable["mod_expires"],
            Webserver::Module::Enable["mod_headers"],
            Webserver::Module::Enable["mod_log_config"],
            Webserver::Module::Enable["mod_mime"],
            Webserver::Module::Enable["mod_reqtimeout"],
            Webserver::Module::Enable["mod_rewrite"],
            Webserver::Module::Enable["mod_security"],
            Webserver::Module::Enable["mod_setenvif"],
            Webserver::Module::Enable["mod_slotmem_shm"],
            Webserver::Module::Enable["mod_socache_shmcb"],
            Webserver::Module::Enable["mod_ssl"],
            Webserver::Module::Enable["mod_status"],
            Webserver::Module::Enable["mod_unixd"],
            Webserver::Module::Enable["php"],
            Webserver::Virtualhost["freebusy.${vhost_domain}"]
        )
}
