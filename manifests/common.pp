class kolab::common inherits kolab::params {
    include kolab::pkg
    include kolab::yum

    include munin

    file { "/etc/kolab/kolab.conf":
        content => template("kolab/kolab/kolab.conf.erb")
    }

    package { "kolab-cli":
        ensure => getvar("kolab::pkg::kolab_cli_version")
    }

    @package { "kolab-saslauthd":
        ensure => getvar("kolab::pkg::kolab_saslauthd_version")
    }

    @package { "postfix-kolab":
        ensure => getvar("kolab::pkg::postfix_kolab_version")
    }

    $primary_domain = getvar("kolab::params::kolab_primary_domain")

    if (!defined(File["/etc/pki/tls/certs/${primary_domain}.ca.cert"])) {
        @file { "/etc/pki/tls/certs/${primary_domain}.ca.cert":
            owner => "root",
            group => "root",
            mode => "444",
            source => [
                    "puppet://$server/private/$environment/files/ssl/${primary_domain}.ca.cert",
                    "puppet://$server/files/ssl/${primary_domain}.ca.cert"
                ]
        }
    }

    if (!defined(File["/etc/pki/tls/private/${primary_domain}.pem"])) {
        @file { "/etc/pki/tls/private/${primary_domain}.pem":
            owner => "root",
            group => "mail",
            mode => "440",
            source => [
                    "puppet://$server/private/$environment/files/ssl/${primary_domain}.pem",
                    "puppet://$server/files/ssl/${primary_domain}.pem"
                ]
        }
    }

    realize(File["/etc/pki/tls/certs/${primary_domain}.ca.cert"])
    realize(File["/etc/pki/tls/private/${primary_domain}.pem"])

    @service { "kolab-saslauthd":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => [
                File["/etc/kolab/kolab.conf"],
                Package["kolab-saslauthd"]
            ],
        subscribe => File["/etc/kolab/kolab.conf"]
    }
}
