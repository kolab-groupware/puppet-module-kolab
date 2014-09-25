class kolab::bonnie::collector inherits kolab::bonnie {
    package { "bonnie-collector":
        ensure => getvar("kolab::pkg::bonnie_collector_version"),
        requires => Yum::Repository["kolab-14-extras-audit"]
    }
}
