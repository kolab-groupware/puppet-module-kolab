class kolab::imap::bonnie {
    file { "/etc/bonnie/bonnie.conf":
        source => "puppet://$server/private/$environment/files/bonnie/bonnie.conf",
        require => Package["bonnie-dealer"],
        owner => "cyrus",
        group => "mail",
        mode => "640"
    }

    package { "bonnie-dealer":
        ensure => getvar("kolab::pkg::bonnie_dealer_version")
    }
}
