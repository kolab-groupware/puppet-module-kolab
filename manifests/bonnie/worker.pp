class kolab::bonnie::worker inherits kolab::bonnie {
    package { "bonnie-worker":
        ensure => getvar("kolab::pkg::bonnie_worker_version"),
        requires => Yum::Repository["kolab-14-extras-audit"]
    }
}
