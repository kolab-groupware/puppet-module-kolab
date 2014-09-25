class kolab::imap::frontend inherits kolab::imap {
    File["/etc/cyrus.conf"] {
        content => template("kolab/cyrus-imapd/cyrus.conf.erb")
    }

    File["/etc/imapd.conf"] {
        content => template("kolab/cyrus-imapd/imapd.conf.erb")
    }

    realize(
            Exec["_usr_lib_cyrus-imapd_mkimap"],
            File["/etc/cyrus.conf"],
            File["/etc/imapd.conf"],
            File["/etc/sysconfig/cyrus-imapd"],
            Nagios::Plugin['check_saslauthd'],
            Package["kolab-saslauthd"],
            Service["cyrus-imapd"],
            Service["kolab-saslauthd"]
        )
}
