use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'String::Similarity::Group',
   VERSION_FROM => 'lib/String/Similarity/Group.pm',
   

   # gen /usr/bin/pmused by Thu Mar 19 16:21:11 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'Getopt::Std::Strict'               => '1.01',
      'Smart::Comments'                   => '1',
      'String::Similarity'                => '1.02',
      'Test::Simple'                      => '0',
      'YAML'                              => '0.66',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [qw(bin/gbs)],
);


