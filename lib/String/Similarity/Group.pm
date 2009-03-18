package String::Similarity::Group;
use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);
use Exporter;
use Carp;
$VERSION = sprintf "%d.%02d", q$Revision: 1.5 $ =~ /(\d+)/g;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/groups groups_lazy groups_hard loners similarest/;
%EXPORT_TAGS = ( all => \@EXPORT_OK );
use String::Similarity 'similarity';

sub _group_hard { # test every element of every group!
   my($min,$aref)=@_;
   ref $aref and ref $aref eq 'ARRAY' or croak("Argument is not an array ref");

   $min >=0 and $min <= 1 or croak("min similarity must be between 0.00 and 1.00");

   my %group;

   ELEMENT: for my $element (@{$aref}) {        
      
      # HARD MATCHING, continue until highest hit
      # traverse all groups, find highest

      my %matched_group = ( score => 0, id => undef );

      GROUP: for my $group_id ( keys %group ){

         my ($highest_element, $score) = similarest( $group{$group_id}, $element, $min ) 
            or next GROUP;
         
         if( $score > $matched_group{score} ){
            %matched_group = ( score => $score, id => $group_id );
         }
      }

      # did we match a group?
      if ( $matched_group{score} ){
        push @{$group{$matched_group{id}}}, $element; 
        next ELEMENT;
      }
      
      # no group matching, make new group.
      $group{$element} = [$element];  
   }

   \%group;
}


sub _group_lazy { # just get the first match
   my($min,$aref)=@_;
   ref $aref and ref $aref eq 'ARRAY' or croak("Argument is not an array ref");
   (($min >=0) and ($min <= 1)) or croak("min similarity must be between 0.00 and 1.00");

   my %group;

   ELEMENT: for my $element (@{$aref}) {  
         
         GROUP: for my $group_id ( keys %group ){

            similarity( $element, $group_id) >= $min 
               or next GROUP;

            push @{$group{$group_id}}, $element;
            next ELEMENT;
         }
         # no group matching, make new group.
         $group{$element} = [$element];
   }

   \%group;
}



sub _group_medium { # get the highest matching group id
   my($min,$aref)=@_;
   ref $aref and ref $aref eq 'ARRAY' or croak("Argument is not an array ref");
   (($min >=0) and ($min <= 1)) or croak("min similarity must be between 0.00 and 1.00");

   my %group;

   ELEMENT: for my $element (@{$aref}) {  
         my ($group_id, $score ) = similarest( [ keys %group ], $element, $min );

         if( $score ){ # one of the group keys had the highest match
            push @{$group{$group_id}}, $element;
            next ELEMENT;
         }

         # no group matching, make new group.
         $group{$element} = [$element];
   }

   \%group;
}




sub loners { map { $_->[0] } grep { scalar @$_ == 1 } values %{_group_medium(@_)} }
sub groups      { grep { scalar @$_  > 1 } values %{_group_medium(@_)} }
sub groups_hard { grep { scalar @$_  > 1 } values %{_group_hard(@_)}   }
sub groups_lazy { grep { scalar @$_  > 1 } values %{_group_lazy(@_)}   }






sub similarest { # may return undef
   my ( $aref, $string, $min )= @_;
   ref $aref and ref $aref eq 'ARRAY' or croak("First argument is array ref");
   defined $string or croak("missing string to test to");
   $min ||=0;

   my %high = ( score => 0, element => undef );

   for my $element ( @$aref ){
      my $score = similarity( $element, $string ) # means that 0 does not make a hit
         or next;
      $score >= $min 
         or next;
      ($score > $high{score}) 
         or next;
      %high = ( score => $score, element => $element );  
   }

   $high{score} or return;

   return ( $high{element}, $high{score} );
}

1;

__END__
see lib/String/Similarity/Group.pod
