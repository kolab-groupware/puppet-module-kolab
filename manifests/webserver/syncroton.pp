class kolab::webserver::syncroton inherits kolab::webserver::common {
    package { "kolab-syncroton":
        ensure => $kolab::pkg::kolab_syncroton_version
    }

    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "activesync.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/activesync.conf.erb"
    }
}
