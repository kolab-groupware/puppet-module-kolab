class kolab::pkg::redhat::santiago::development::kolab_14 inherits kolab::pkg::redhat::santiago::development {
    if (!defined(Yum::Repository["kolab-14-extras-puppet"])) {
        $puppet_version = "3.7.1-1.el6.kolab_14"
    } else {
        $puppet_version = "installed"
    }
}
