class kolab::haproxy {
    file { "/etc/haproxy/haproxy.cfg":
        source => "puppet://$server/private/$environment/kolab/haproxy/haproxy.cfg",
        require => Package["haproxy"],
        notify => Service["haproxy"]
    }

    file { "/etc/haproxy/haproxy.cfg-from-tpl":
        content => template('kolab/haproxy/haproxy.cfg.erb'),
        require => Package["haproxy"]
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
