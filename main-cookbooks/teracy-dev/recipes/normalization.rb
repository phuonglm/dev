#
# Author:: hieptranquoc <hieptq8888@gmail.com>
# Cookbook Name:: teracy-dev
# Recipe:: normalization
#
# Copyright 2013 - current, Teracy, Inc.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.

#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.

#     3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
#        to endorse or promote products derived from this software without
#        specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

bash 'check exist and install bash-completion' do
  code <<-EOH
    apt-get install --reinstall -f -y bash-completion
    . /etc/bash_completion
    EOH
  not_if { ::File.exist?('/etc/bash_completion') && ::File.exist?('/usr/share/bash-completion/bash_completion') }
end

bash 'set default route external interface' do
  code <<-EOH
    IFaceCount=$(ls -la /var/lib/dhcp/* | awk '{ gsub("/var/lib/dhcp/dhclient.","",$9); gsub(".leases","", $9); print $9}' | wc -l);
    if [ $IFaceCount -gt 1 ]; then
      InTF=$(ls -la /var/lib/dhcp/* | awk '{ gsub("/var/lib/dhcp/dhclient.","",$9); gsub(".leases","", $9); print $9}' | tail -n1);
      GATE=$(cat '/var/lib/dhcp/dhclient.'$InTF'.leases' | grep routers | tail -n1 | awk '{print substr($3, 1, length($3)-1)}');
      route delete default && route add default gw $GATE dev $InTF;
    fi
    EOH
end