class kolab::bonnie {
    file { "/etc/bonnie/bonnie.conf":
        source => "puppet://$server/private/$environment/files/bonnie/bonnie.conf",
        require => Package["bonnie-dealer"],
        owner => "cyrus",
        group => "mail",
        mode => "640"
    }
}
