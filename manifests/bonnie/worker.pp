class kolab::bonnie::worker inherits kolab::bonnie {
    package { "bonnie-worker":
        ensure => getvar("kolab::pkg::bonnie_worker_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    service { "bonnie-worker":
        ensure => running,
        enable => true,
        require => [
            File["/etc/bonnie/bonnie.conf"],
            Package["bonnie-worker"]
        ]
    }
}
