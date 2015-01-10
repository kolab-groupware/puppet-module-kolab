class kolab::haproxy {
    file { "/etc/haproxy/haproxy.cfg":
        content => template('kolab/haproxy/haproxy.cfg.erb'),
        require => Package["haproxy"],
        notify => Service["haproxy"]
    }

    package { "haproxy":
        ensure => installed,
        notify => Service["haproxy"]
    }

    service { "haproxy":
        ensure => running,
        enable => true,
        require => [
            File["/etc/haproxy/haproxy.cfg"],
            Package["haproxy"]
        ]
    }
}
