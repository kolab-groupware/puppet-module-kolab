class kolab::yum inherits kolab::params {
    include yum::standard

    yum::repository { [
            "kolab-${kolab::params::kolab_version}-release",
            "kolab-${kolab::params::kolab_version}-updates"
        ]:
        enable => true,
        gpgkey => true
    }

    case $kolab::params::kolab_version {
        "13", "14": {
            file { "/etc/pki/tls/certs/mirror.kolabsys.com.ca.cert":
                owner => root,
                group => root,
                mode => "640",
                source => [
                        "puppet://$server/private/$environment/yum/ssl/mirror.kolabsys.com.ca.cert"
                    ]
            }

            file { "/etc/pki/tls/private/mirror.kolabsys.com.client.pem":
                owner => root,
                group => root,
                mode => "640",
                source => [
                        "puppet://$server/private/$environment/yum/ssl/mirror.kolabsys.com.client.pem",
                        "puppet://$server/files/yum/ssl/mirror.kolabsys.com.client.pem"
                    ]
            }

            # TODO: Should become a dependency of the -release packages
            package { "yum-plugin-priorities":
                ensure => installed
            }

            yum::repository { "kolab-${kolab::params::kolab_version}-updates-testing":
                enable => $environment ? {
                    "testing" => true,
                    "development" => true,
                    default => false
                },
                gpgkey => true
            }

            yum::repository { "kolab-${kolab::params::kolab_version}-development":
                enable => $environment ? {
                    "development" => true,
                    default => $kolab::params::kolab_version ? {
                        "14" => true,
                        default => false
                    }
                },
                gpgkey => true
            }
        }

    }

    case $kolab::params::kolab_version {
            "14": {
                    if (!defined(Yum::Repository["kolab-14-extras-puppet"])) {
                            yum::repository { "kolab-14-extras-puppet":
                                    enable => true,
                                    gpgkey => true
                                }
                        }

                    if (!defined(Package["puppet"])) {
                            package { "puppet":
                                    ensure => getvar("kolab::pkg::puppet_version")
                                }
                        }
                }
        }
}
