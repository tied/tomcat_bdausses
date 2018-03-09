# tomcat_bdausses Cookbook

This cookbook is an example for installing Tomcat on RHEL based systems.  It installs Java, then installs Tomcat.  Finally, it sets up the systemd_unit for Tomcat and starts it.

## Requirements

### Platforms

- Any RHEL based 64-bit Linux Distro

### Chef

- Chef 12.1 or later

## Usage

### tomcat_bdausses::install

Just include `tomcat_bdausses::install` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[tomcat_bdausses::install]"
  ]
}
```

## License and Authors

Authors: Brad Dausses - <brad.dausses@gmail.com>
