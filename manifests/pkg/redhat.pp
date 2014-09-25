class kolab::pkg::redhat inherits kolab::pkg {
    case $osmajorver {
            "6": {
                    include kolab::pkg::santiago
                    $osname = "santiago"
                }
            "7": {
                    include kolab::pkg::maipo
                    $osname = "maipo"
                }
        }
}
