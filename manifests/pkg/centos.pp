class kolab::pkg::centos inherits kolab::pkg {
    case $osmajorver {
            "6": {
                    include kolab::pkg::centos::santiago
                    $osname = "santiago"
                }
            "7": {
                    include kolab::pkg::centos::maipo
                    $osname = "maipo"
                }
        }
}
