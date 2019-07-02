#!/usr/bin/perl -w

use strict;
use warnings;

my @naughty;
my @functions;
my @output;
my @newoutfile;

my $numfunctions = 0;

my $naughty_file = "list.txt";
my $out_file = "lexprofanity.l";

# Main routine. Order of function calls to complete the program.
get_naughty();
get_functions();
get_outfile();
combine_functions();
print_outfile();
success_exit();


sub success_exit {
    print "\nProgram Completed successfully! Exit code 0.\n";
    exit 0;
}

sub print_outfile {
    if (open(my $fh, '>', $out_file)) {
        foreach my $n (@newoutfile) {
            print $fh $n;
        }
            close $fh;
            print "\nGot here\n";
    }

}

sub printNewoutfile  {
    foreach my $n (@newoutfile) {
        print $n;
    }
}

sub printFunctions  {
    foreach my $n (@functions) {
        print $n;
    }
}

sub printLex  {
    foreach my $n (@output) {
        print $n;
    }
}

sub combine_functions {
    my $current_line = 0;
    my $first = 0;
    foreach my $n (@output) {
        @newoutfile[$current_line] = $n;
        $current_line++;
        chomp($n);
        if ($n eq '%%') {
            if ($first == 0) {
                foreach my $m (@functions) {
                    @newoutfile[$current_line] = $m;
                    $current_line++;
                }
                $first = 1;
            }
        }


    }

}

sub get_outfile {
    my $line;
    my $linenum = 0;
    my $first = 0;
    # open file, read line, split line, store values in hash.
    if (open my $fh, '<', $out_file) {
        while ($line = <$fh>) {

            @output[$linenum] = $line;
            $linenum = $linenum + 1;

        } # end of lines, while loop.

    } # end of file open

}

sub get_functions {
    my $numfunctions = 0;
    foreach my $n (@naughty) {
        my $string;
        $string .= "\n";
        $string .= "{Zo1_any}";

      for my $c (split //, $n) {
          my $U = uc $c;
          my $L = lc $c;

          my $var = substr($n,length($n)-1,1);
          if ($c eq $var) {
              $string .= "[$L|$U]";
          }
          else {
              $string .= "[$L|$U]+{ALL}";
          }
      }
      $string .= "{Zo1_any}  {\n";
      $string .= "\tcompareLongest(yytext), insertId(yytext, yylineno), naughty_count++;\n}\n";


      @functions[$numfunctions] = $string;
      $numfunctions++;
    }
}


sub get_naughty {
    # Temp for currently being read line.
    my $line;

    # Temp for the two values we wish to derive from the line.
    my $word;

    my $current_line = 0;

    # open file, read line, split line, store values in hash.
    if (open my $fh, '<', $naughty_file) {
        while ($line = <$fh>) {

            foreach $word (split /[^a-zA-Z0-9_\s]/, $line) {
                if (length $word >= 2) {
                    chomp($word);
                    $word =~ s/[^\S]+//g;
                    @naughty[$current_line] = $word;
                    $current_line++;
                }
            } # end of spliting words on line.
        } # end of lines, while loop.

    } # end of file open


}
