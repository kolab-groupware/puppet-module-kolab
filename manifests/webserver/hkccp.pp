class kolab::webserver::hkccp inherits kolab::webserver::common {
    package { "kolab-hkccp":
        ensure => $kolab::pkg::kolab_hkccp_version
    }

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "cockpit.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/cockpit.conf.erb"
    }
}
