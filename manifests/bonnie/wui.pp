class kolab::bonnie::wui inherits kolab::bonnie {
    include webserver

    package { "bonnie-wui":
        ensure => getvar("kolab::pkg::bonnie_wui_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    webserver::module::enable { "mod_wsgi":
        enable => true
    }

    @webserver::virtualhost { "bonnie.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/bonnie.conf.erb"
    }

    realize(Webserver::Virtualhost["bonnie.${vhost_domain}"])
}
