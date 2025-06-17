###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2010
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
 
package Ocsinventory::Agent::Modules::Uptime;
 
sub new {
 
   my $name="uptime";   # Name of the module
 
   my (undef,$context) = @_;
   my $self = {};
 
   #Create a special logger for the module
   $self->{logger} = new Ocsinventory::Logger ({
            config => $context->{config}
   });
 
   $self->{logger}->{header}="[$name]";
 
   $self->{context}=$context;
 
   $self->{structure}= {
                        name => $name,
                        start_handler => undef,    #or undef if don't use this hook
                        prolog_writer => undef,    #or undef if don't use this hook
                        prolog_reader => undef,    #or undef if don't use this hook
                        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
                        end_handler => undef    #or undef if don't use this hook
   };
 
   bless $self;
}
 
######### Hook methods ############
 
sub uptime_inventory_handler {
    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};

    $logger->debug("Entering uptime_inventory_handler");

    my ($uptime, $datetime);

    if ($^O eq 'darwin') {
        # macOS-specific boot time retrieval
        my $boottime = `sysctl -n kern.boottime`;
        if ($boottime =~ /sec = (\d+)/) {
            $boottime = $1;
            my $currtime = time();
            $uptime = $currtime - $boottime;
            $datetime = `date -r $boottime "+%Y-%m-%d %H:%M:%S"`;
            chomp($datetime);
        } else {
            $logger->error("Failed to parse boot time from sysctl output");
            return;
        }
    } else {
        # Linux-specific uptime retrieval
        my $uptime_output = `cat /proc/uptime`;
        if ($uptime_output =~ /^(\d+(\.\d+)?)/) {
            $uptime = int($1);
            $datetime = `uptime -s`;
            chomp($datetime);
        } else {
            $logger->error("Failed to parse uptime from /proc/uptime");
            return;
        }
    }

    # Calculate days, hours, minutes, and seconds
    my $days = int($uptime / 86400);
    my $hours = int(($uptime % 86400) / 3600);
    my $minutes = int(($uptime % 3600) / 60);
    my $seconds = $uptime % 60;

    # Format uptime string
    my $uptime_str = "$days days $hours hours $minutes minutes $seconds seconds";

    # Push the uptime data to the XML tags
    push @{$common->{xmltags}->{UPTIME}}, { DURATION => [$uptime_str], LOG_DATE => [$datetime] };

    $logger->debug("Uptime: $uptime_str, Boot Time: $datetime");
}
 
1;
