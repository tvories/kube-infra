{
  "ignition": {
    "version": "3.2.0"
  },
  "storage": {
    "files": [
      {
        "overwrite": true,
        "path": "/etc/sysconfig/network/ifcfg-eth0",
        "contents": {
          "source": "data:,BOOTPROTO%3D'static'%0ASTARTMODE%3D'auto'%0ANAME%3D'eth0%20Network%20Connection'%0ANETMASK%3D'${netmask}'%0ABROADCAST%3D''%0AIPADDR%3D'${ip_address}%2F24'%0AMTU%3D'1500'%0ANETWORK%3D''%0AREMOTE_IPADDR%3D''%0AUSERCONTROL%3D'no'%0A"
        }
      },
      {
        "path": "/etc/sysconfig/network/routes",
        "contents": {
          "source": "data:,default%20${gateway}%20-%20-%20"
        }
      },
      {
        "overwrite": true,
        "path": "/etc/resolv.conf",
        "contents": {
          "source": "data:,%{for ns in nameservers }nameserver%20${ns}%0A%{ endfor }%0Asearch%20${ dns_domain }%0A"
        }
      },
      {
        "overwrite": true,
        "path": "/etc/hostname",
        "contents": {
          "source": "data:,${ hostname }"
        },
        "mode": 420
      }
    ]
  }
}
