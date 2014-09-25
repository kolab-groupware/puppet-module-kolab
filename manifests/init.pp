class kolab inherits kolab::params {

    # A full-blown Cyrus IMAP server
    include kolab::imap
    # A 389 Directory Server
    include kolab::ldap
    # A self-contained mail exchanger (internal, external (in and out),
    # submission, anti-spam, anti-virus)
    include kolab::mx
    # A webserver
    include kolab::webserver
    include kolab::yum
}
