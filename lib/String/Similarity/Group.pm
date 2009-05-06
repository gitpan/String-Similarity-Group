package String::Similarity::Group;
use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);
use Exporter;
use Carp;
$VERSION = sprintf "%d.%02d", q$Revision: 1.10 $ =~ /(\d+)/g;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/groups groups_lazy groups_hard loners similarest sort_by_similarity/;
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

         $score and  # one of the group keys had the highest match
            ( push @{$group{$group_id}}, $element ) 
            and next ELEMENT;
         

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
   
   my %high = ( score => ( ($min || 0 ) - 0.01 ), element => undef );

   for ( @$aref ){

      my $score = similarity( $_, $string, $high{score} ) # means that 0 does not make a hit
         or next;
      ($score > $high{score}) or next;
      $high{score} = $score;
      $high{element} = $_;
   }

   $high{element} or return;      
   wantarray ? ( $high{element}, $high{score} ) : $high{element};
}


sub sort_by_similarity {
   my ($aref, $string, $min ) = @_;
   ref $aref and ref $aref eq 'ARRAY' or croak("First argument is array ref");
   defined $string or croak("missing string to test to");
   #$min ||=0;

   # rank them all first
   my %score;
   for my $element (@$aref){

      my $score = similarity( $element, $string, $min );
      $score ||= 0;      

      #(printf STDERR "%s %-18s min:%s, got:%0.2f\n", $string, $element, $min, $score) if $DEBUG;
      if ( defined $min ){
         $score >= $min or next;
      }

      $score{$element} = $score;      
   }  

   my @sorted = sort { $score{$b} <=> $score{$a} } keys %score;#@$aref;
   wantarray ? @sorted : \@sorted;
}

1;

__END__
see lib/String/Similarity/Group.pod
