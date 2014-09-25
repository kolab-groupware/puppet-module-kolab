class kolab::webserver::chwala inherits kolab::webserver::common {
    realize(
            Package["chwala"]
        )

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "files.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/files.conf.erb"
    }
}
