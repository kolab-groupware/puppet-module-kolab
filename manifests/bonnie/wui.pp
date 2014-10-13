class kolab::bonnie::wui inherits kolab::bonnie {
    include webserver

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    package { "bonnie-flask":
        ensure => getvar("kolab::pkg::bonnie_flask_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    package { "bonnie-wui":
        ensure => getvar("kolab::pkg::bonnie_wui_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    if (!defined(Webserver::Module::Enable["mod_authz_core"])) {
        @webserver::module::enable { "mod_authz_core": }
    }

    if (!defined(Webserver::Module::Enable["mod_slotmem_shm"])) {
        @webserver::module::enable { "mod_slotmem_shm": }
    }

    if (!defined(Webserver::Module::Enable["mod_socache_shmcb"])) {
        @webserver::module::enable { "mod_socache_shmcb": }
    }

    if (!defined(Webserver::Module::Enable["mod_ssl"])) {
        @webserver::module::enable { "mod_ssl": }
    }

    if (!defined(Webserver::Module::Enable["mod_unixd"])) {
        @webserver::module::enable { "mod_unixd": }
    }

    webserver::module::enable { "mod_wsgi":
    }

    @webserver::virtualhost { "bonnie.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/bonnie.conf.erb"
    }

    realize(
            Webserver::Module::Enable["mod_authz_core"],
            Webserver::Module::Enable["mod_slotmem_shm"],
            Webserver::Module::Enable["mod_socache_shmcb"],
            Webserver::Module::Enable["mod_ssl"],
            Webserver::Module::Enable["mod_unixd"],
            Webserver::Virtualhost["bonnie.${vhost_domain}"]
        )
}
