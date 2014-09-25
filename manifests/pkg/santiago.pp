class kolab::pkg::redhat::santiago inherits kolab::pkg::redhat {
    include "kolab::pkg::redhat::santiago::${environment}"

    $kolab_dist_tag = 'el6'
}
