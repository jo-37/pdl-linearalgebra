use strict;
use warnings;
use PDL::LiteF;
use PDL::MatrixOps qw(identity);
use PDL::LinearAlgebra;
use PDL::LinearAlgebra::Trans qw //;
use PDL::LinearAlgebra::Complex;
use PDL::Complex;
use Test::More;

sub fapprox {
	my($a,$b) = @_;
	($a-$b)->abs->max < 0.0001;
}
# PDL::Complex only
sub runtest {
  local $Test::Builder::Level = $Test::Builder::Level + 1;
  my ($in, $method, $expected_cplx, $extra) = @_;
  $expected_cplx = $expected_cplx->[1] if ref $expected_cplx eq 'ARRAY';
  $_ = PDL::Complex::r2C($_) for $in, $expected_cplx;
  my ($got) = $in->$method(map ref() && ref() ne 'CODE' ? PDL::Complex::r2C($_) : $_, @{$extra||[]});
  ok fapprox($got, $expected_cplx), "PDL::Complex $method" or diag "got: $got\nexpected: $expected_cplx";
}

my $aa = cplx random(2,2,2);
runtest($aa, 't', $aa->xchg(1,2));

$aa = sequence(2,2,2)->cplx + 1;
runtest($aa, 'norm', my $aa_exp = PDL::Complex->from_native(pdl <<'EOF'));
[
 [0.223606+0.223606i 0.670820+0.670820i]
 [0.410997+0.410997i 0.575396+0.575396i]
]
EOF
runtest($aa, 'norm', $aa_exp->abs, [1]);
runtest($aa, 'norm', $aa_exp->t, [0,1]);

do './t/common.pl'; die if $@;

done_testing;
