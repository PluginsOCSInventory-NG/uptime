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
 
   #I add the treatments for my new killer feature
   $logger->debug("Yeah you are in uptime_inventory_handler :)");
 
   if ($^O ne 'Darwin') {
       my $luptime = `cat /proc/uptime | awk '{print $1}'`;
       my $uptime = undef;
       my $datetime = `uptime -s`;
   } else {
       my $boottime = `sysctl -n kern.boottime | awk -F '[,]' '{print \$4}`;
       chomp $boottime;
       my $currtime = `date -j +'%s'`;
       chomp $currtime;

       my $luptime=$currtime-$boottime;
       my $uptime=undef;
       my $datetime = `date -j -r $boottime+'%Y-%0m-%0d %H:%M:%S'`;
       chomp $datetime;
   }

   # These help us calculate the minutes and hours
   my $min=60;
   my $hour = $min*60;
   my $day = $hour*24;
 
   my $minutes = 0;
   my $hours = 0;
   my $days = 0;
 
   # Make the uptime number integer
   my $seconds = int($luptime);
 
   while ($seconds >= $min) {
        while ($seconds >= $hour) {
                while ($seconds >= $day) {
                        $seconds -= $day;
                        ++$days;
                }
                $seconds -= $hour;
                ++$hours;
        }
        $seconds -= $min;
        ++$minutes
   }
   if($seconds < 10) { $seconds = "0$seconds"; }
   if($minutes < 10) { $minutes = "0$minutes"; }
   if($hours < 10) {$hours = "0$hours"; }
   if($days < 10) {$days = "0$days"; }
 
   $uptime = "$days days $hours hours $minutes minutes";
 
   push @{$common->{xmltags}->{UPTIME}},
   {
      DURATION => [$uptime],
      LOG_DATE => [$datetime]
   };
}
 
1;
