use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'String::Similarity::Group',
   VERSION_FROM => 'lib/String/Similarity/Group.pm',
   

   # gen /usr/bin/pmused by Wed Mar 18 11:46:09 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'Getopt::Std::Strict'               => '1.01',
      'String::Similarity'                => '1.02',
      'Test::Simple'                      => '0',
      'YAML'                              => '0.66',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [qw(bin/gbs)],
);


