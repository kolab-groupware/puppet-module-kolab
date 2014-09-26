class kolab::webserver::roundcubemail inherits kolab::webserver::common {
    $vhost_domain = getvar("kolab::params::kolab_primary_domain")

    @webserver::virtualhost { "webmail.${vhost_domain}":
        enable => true,
        certificate => true,
        template => "kolab/webserver/sites/webmail.conf.erb"
    }

    realize(
            File["/etc/php.d/apc.ini"],
            File["/etc/php.d/memcache.ini"],
            File["/etc/roundcubemail/"],
            File["/etc/roundcubemail/calendar.inc.php"],
            File["/etc/roundcubemail/config.inc.php"],
            File["/etc/roundcubemail/kolab_auth.inc.php"],
            File["/etc/roundcubemail/kolab_delegation.inc.php"],
            File["/etc/roundcubemail/libkolab.inc.php"],
            File["/etc/roundcubemail/password.inc.php"],
            Package["php-pecl-apc"],
            Package["php-pecl-memcache"],
            Package["roundcubemail"],
            Package["roundcubemail-plugin-archive"],
            Package["roundcubemail-plugin-contextmenu"],
            Package["roundcubemail-plugin-markasjunk"],
            Package["roundcubemail-plugins-kolab"],
            Webserver::Module::Enable["mod_authz_core"],
            Webserver::Module::Enable["mod_slotmem_shm"],
            Webserver::Module::Enable["mod_socache_shmcb"],
            Webserver::Module::Enable["mod_ssl"],
            Webserver::Module::Enable["mod_unixd"],
            Webserver::Module::Enable["php"],
            Webserver::Virtualhost["webmail.${vhost_domain}"]
        )

}
