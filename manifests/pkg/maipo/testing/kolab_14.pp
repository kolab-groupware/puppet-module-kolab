class kolab::pkg::maipo::testing::kolab_14 inherits kolab::pkg::maipo::testing {
    if (!defined(Yum::Repository["kolab-14-extras-puppet"])) {
        $puppet_version = "3.7.1-1.el6.kolab_14"
    } else {
        $puppet_version = "installed"
    }
}
