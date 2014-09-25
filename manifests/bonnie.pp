class kolab::bonnie {
    yum::repository { "kolab-14-extras-audit":
        enable => true
    }

    file { "/etc/bonnie/bonnie.conf":
        source => "puppet://$server/private/$environment/files/bonnie/bonnie.conf",
        owner => "cyrus",
        group => "mail",
        mode => "640"
    }
}
