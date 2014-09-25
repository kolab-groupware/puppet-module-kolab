class kolab::pkg::centos::maipo inherits kolab::pkg::centos {
    include "kolab::pkg::centos::maipo::${environment}"

    $kolab_dist_tag = 'el7'
}
