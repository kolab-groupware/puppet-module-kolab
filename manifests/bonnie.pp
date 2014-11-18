class kolab::bonnie {
    file { "/etc/bonnie/bonnie.conf":
        source => "puppet://$server/private/$environment/files/bonnie/bonnie.conf",
        owner => "bonnie",
        group => "bonnie",
        mode => "640",
        require => Package["bonnie"]
    }

    package { "bonnie":
        ensure => getvar("kolab::pkg::bonnie_version"),
        require => Yum::Repository["kolab-14-extras-audit"]
    }

    yum::repository { "kolab-14-extras-audit":
        enable => true
    }
}
