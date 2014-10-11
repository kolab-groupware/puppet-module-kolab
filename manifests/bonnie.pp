class kolab::bonnie {
    file { "/etc/bonnie/bonnie.conf":
        source => "puppet://$server/private/$environment/files/bonnie/bonnie.conf",
        owner => "cyrus",
        group => "mail",
        mode => "640",
        require => User["cyrus"]
    }

    if (!defined(User["cyrus"])) {
        @user { "cyrus":
            ensure => present,
            uid => 76,
            gid => 12,
            comment => "Cyrus IMAP Server",
            shell => "/sbin/nologin",
            home => "/var/lib/imap"
        }
    }

    realize(User["cyrus"])

    yum::repository { "kolab-14-extras-audit":
        enable => true
    }
}
