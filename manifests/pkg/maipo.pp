class kolab::pkg::redhat::maipo inherits kolab::pkg::redhat {
    include "kolab::pkg::redhat::maipo::${environment}"

    $kolab_dist_tag = 'el7'
}
