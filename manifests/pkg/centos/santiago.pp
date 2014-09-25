class kolab::pkg::centos::santiago inherits kolab::pkg::centos {
    include "kolab::pkg::centos::santiago::${environment}"

    $kolab_dist_tag = 'el6'
}
