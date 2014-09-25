class kolab::bonnie::dealer inherits kolab::bonnie {
    package { "bonnie-dealer":
        ensure => getvar("kolab::pkg::bonnie_dealer_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }
}
