class kolab::pkg::maipo inherits kolab::pkg::redhat {
    include "kolab::pkg::maipo::${environment}"

    $kolab_dist_tag = 'el7'
}
