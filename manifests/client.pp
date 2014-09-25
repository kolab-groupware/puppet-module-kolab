class kolab::client inherits kolab::params {
    package { "kolab-desktop-client":
        ensure => installed
    }
}
