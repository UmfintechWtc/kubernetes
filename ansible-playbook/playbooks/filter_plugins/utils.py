#!/usr/bin/pytrhon
import re
def get_host_num(master_groups,nodeHost_index,hostname):
    """
    :param host: hostname
    :return: match num
    """
    num_list = re.findall("\d",hostname)
    hostname_num = "".join(num_list)
    if len(hostname_num) == 0:
        hostname_num = len(master_groups) + nodeHost_index + 1
    else:
        hostname_num = hostname_num
    return (hostname_num)

class FilterModule(object):
    def filters(self):
        return {
            'get_host_num': get_host_num
        }
