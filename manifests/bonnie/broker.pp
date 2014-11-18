class kolab::bonnie::broker inherits kolab::bonnie {
    package { "bonnie-broker":
        ensure => getvar("kolab::pkg::bonnie_broker_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    service { "bonnie-broker":
        ensure => running,
        enable => true,
        require => [
            File["/etc/bonnie/bonnie.conf"],
            Package["bonnie-broker"]
        ]
    }
}
