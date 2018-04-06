class hosting_basesetup::proxy (
    String $http_host = $::hosting_basesetup::proxy_http_host,
    String $http_port = $::hosting_basesetup::proxy_http_port,
    Boolean $https = $::hosting_basesetup::proxy_https,
) {


  if ($http_host != "" and $http_port){
    file { '/etc/profile.d/proxy-http.sh':
        owner => 'root',
        group => 'root',
        mode => '0755',
        content => "
http_proxy=http://${http_host}:${http_port}
export http_proxy
        "
     }
     if $https {
        file { '/etc/profile.d/proxy-https.sh':
            owner => 'root',
            group => 'root',
            mode => '0755',
            content => "
    https_proxy=http://${http_host}:${http_port}
    export https_proxy
            "
         }
     }
  }else{
    file { '/etc/profile.d/proxy-https.sh':
       ensure => absent,
    }
    file { '/etc/profile.d/proxy-http.sh':
       ensure => absent,
    }
  }
}
