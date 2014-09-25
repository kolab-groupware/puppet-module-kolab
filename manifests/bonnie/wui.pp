class kolab::bonnie::wui inherits kolab::bonnie {
    package { "bonnie-wui":
        ensure => getvar("kolab::pkg::bonnie_wui_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }
}
