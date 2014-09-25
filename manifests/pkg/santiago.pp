class kolab::pkg::santiago inherits kolab::pkg::redhat {
    include "kolab::pkg::santiago::${environment}"

    $kolab_dist_tag = 'el6'
}
