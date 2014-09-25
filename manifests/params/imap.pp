class kolab::params::imap (
            $imap_storage_partitions = $kolab::params::imap_storage_partitions,
            $imap_storage_meta_base_path = $kolab::params::imap_storage_meta_base_path,
            $imap_storage_spool_base_path = $kolab::params::imap_storage_spool_base_path,

            $imap_configdir = $kolab::params::imap_configdir,
            $imap_duplicate_db_path = $kolab::params::imap_duplicate_db_path,
            $imap_ptscache_db_path = $kolab::params::imap_ptscache_db_path,
            $imap_sievedir = $kolab::params::imap_sievedir,
            $imap_socket_path = $kolab::params::imap_socket_path,
            $imap_statuscache_db_path = $kolab::params::imap_statuscache_db_path,
            $imap_temp_path = $kolab::params::imap_temp_path,
            $imap_tlscache_db_path = $kolab::params::imap_tlscache_db_path,
        ) inherits kolab::params {
}
