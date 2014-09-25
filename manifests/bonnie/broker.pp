class kolab::bonnie::broker inherits kolab::bonnie {
    package { "bonnie-broker":
        ensure => getvar("kolab::pkg::bonnie_broker_version")
    }
}
