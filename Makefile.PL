use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'String::Similarity::Group',
   VERSION_FROM => 'lib/String/Similarity/Group.pm',
   

   # gen /usr/bin/pmused by Thu May  7 14:34:14 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'Getopt::Std::Strict'               => '1.01',
      'LEOCHARRE::Dir'                    => '1.06',
      'Smart::Comments'                   => '1',
      'String::Similarity'                => '1.03',
      'Test::Simple'                      => '0',
      'Time::Format'                      => '1.02',
      'Time::HiRes'                       => '1.65',
      'YAML'                              => '0.62',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [qw(bin/gbs)],
);


