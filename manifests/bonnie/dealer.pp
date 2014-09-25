class kolab::bonnie::dealer inherits kolab::bonnie {
    package { "bonnie-dealer":
        ensure => getvar("kolab::pkg::bonnie_dealer_version"),
        requires => Yum::Repository["kolab-14-extras-audit"]
    }
}
