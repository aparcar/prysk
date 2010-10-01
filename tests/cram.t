The $PYTHON environment variable should be set when running this test
from Python.

  $ [ -n "$PYTHON" ] || PYTHON="`which python`"
  $ if [ -n "$COVERAGE" ]; then
  >   coverage erase
  >   alias cram="`which coverage` run --branch -a $TESTDIR/../cram.py"
  > else
  >   alias cram="$PYTHON $TESTDIR/../cram.py"
  > fi
  $ command -v md5 > /dev/null || alias md5=md5sum

Usage:

  $ cram -h
  [Uu]sage: cram \[OPTIONS\] TESTS\.\.\. (re)
  
  [Oo]ptions: (re)
    -h, --help         show this help message and exit
    -V, --version      show version information and exit
    -q, --quiet        don't print diffs
    -v, --verbose      show filenames and test status
    -i, --interactive  interactively merge changed test output
    -y, --yes          answer yes to all questions
    -n, --no           answer no to all questions
    --keep-tmpdir      keep temporary directories
    -E                 don't reset common environment variables
  $ cram -V
  Cram CLI testing framework (version 0.4)
  
  Copyright (C) 2010 Brodie Rao <brodie@bitheap.org> and others
  This is free software; see the source for copying conditions. There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  $ cram
  [Uu]sage: cram \[OPTIONS\] TESTS\.\.\. (re)
  [2]
  $ cram -y -n
  options -y and -n are mutually exclusive
  [2]
  $ cram non-existent also-not-here
  no such file: non-existent
  [2]

Copy in example tests:

  $ cp -R "$TESTDIR"/../examples .
  $ find . -name '*.err' -exec rm '{}' \;

Run cram examples:

  $ cram -q examples examples/fail.t
  .s.!s.
  # Ran 6 tests, 2 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)
  $ rm examples/fail.t.err

Verbose mode:

  $ cram -q -v examples examples/fail.t
  examples/bare.t: passed
  examples/empty.t: empty
  examples/env.t: passed
  examples/fail.t: failed
  examples/skip.t: skipped
  examples/test.t: passed
  # Ran 6 tests, 2 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)
  $ rm examples/fail.t.err

Interactive mode (don't merge):

  $ cram -n -i examples/fail.t
  !
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] n
  
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)

Interactive mode (merge):

  $ cp examples/fail.t examples/fail.t.orig
  $ cram -y -i examples/fail.t
  !
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] y
  patching file */fail.t (glob)
  
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t
  .*\b44b27872ea5380df986e19ba23aed934\b.* (re)
  $ mv examples/fail.t.orig examples/fail.t

Verbose interactive mode (answer manually and don't merge):

  $ printf 'bad\nn\n' | cram -v -i examples/fail.t
  examples/fail.t: failed
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] Accept this change? [yN] # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)
  $ printf 'bad\n\n' | cram -v -i examples/fail.t
  examples/fail.t: failed
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] Accept this change? [yN] # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)

Verbose interactive mode (answer manually and merge):

  $ cp examples/fail.t examples/fail.t.orig
  $ printf 'bad\ny\n' | cram -v -i examples/fail.t
  examples/fail.t: failed
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] Accept this change? [yN] patching file */fail.t (glob)
  examples/fail.t: merged output
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t
  .*\b44b27872ea5380df986e19ba23aed934\b.* (re)
  $ mv examples/fail.t.orig examples/fail.t

Test missing patch(1) and patch(1) error:

  $ PATH=. cram -i examples/fail.t
  patch(1) required for -i
  [2]
  $ cat > patch <<EOF
  > #!/bin/sh
  > echo "patch failed" 1>&2
  > exit 1
  > EOF
  $ chmod +x patch
  $ PATH=. cram -y -i examples/fail.t
  !
  --- */examples/fail.t (glob)
  +++ */examples/fail.t.err (glob)
  @@ -1,14 +1,15 @@
   Wrong output and bad regexes:
   
     $ echo 1
  -  2
  +  1
     $ printf '1\nfoo\n1\n'
  -  +++ (re)
  -  foo\ (re)
  -   (re)
  +  1
  +  foo
  +  1
   
   Offset regular expression:
   
     $ printf 'foo\n\n1\n'
  +  foo
     
     \d (re)
  Accept this change? [yN] y
  patch failed
  examples/fail.t: merge failed
  
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ md5 examples/fail.t examples/fail.t.err
  .*\bec9a94814a64428cd2327580164a01b9\b.* (re)
  .*\b114b031c5361553b32d9337a31f39ce5\b.* (re)
  $ rm patch examples/fail.t.err

Test that a fixed .err file is deleted:

  $ echo "  $ echo 1" > fixed.t
  $ cram fixed.t
  !
  --- */fixed.t (glob)
  +++ */fixed.t.err (glob)
  @@ -1,1 +1,2 @@
     $ echo 1
  +  1
  
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ cp fixed.t.err fixed.t
  $ cram fixed.t
  .
  # Ran 1 tests, 0 skipped, 0 failed.
  $ test \! -f fixed.t.err
  $ rm fixed.t

Don't sterilize environment:

  $ TZ=foo; export TZ
  $ CDPATH=foo; export CDPATH
  $ COLUMNS=4815162342; export COLUMNS
  $ GREP_OPTIONS=foo; export GREP_OPTIONS
  $ cram -E examples/env.t
  !
  \-\-\- .*/examples/env\.t\s* (re)
  \+\+\+ .*/examples/env\.t\.err\s* (re)
  @@ -7,13 +7,13 @@
     $ echo "$LANGUAGE"
     C
     $ echo "$TZ"
  -  GMT
  +  foo
     $ echo "$CDPATH"
  -  
  +  foo
     $ echo "$COLUMNS"
  -  80
  +  4815162342
     $ echo "$GREP_OPTIONS"
  -  
  +  foo
     $ echo "$CRAMTMP"
     .+ (re)
     $ echo "$TESTDIR"
  
  # Ran 1 tests, 0 skipped, 1 failed.
  [1]
  $ rm examples/env.t.err

Test --keep-tmpdir:

  $ cram -q --keep-tmpdir examples/test.t | while read line; do
  >   echo "$line" 1>&2
  >   msg=`echo "$line" | cut -d ' ' -f 1-4`
  >   if [ "$msg" = '# Kept temporary directory:' ]; then
  >     echo "$line" | cut -d ' ' -f 5
  >   fi
  > done > keeptmp
  .
  # Ran 1 tests, 0 skipped, 0 failed.
  # Kept temporary directory: */cramtests-* (glob)
  $ ls "`cat keeptmp`" | sort
  test.t
  tmp

Note: We can't set the locale to foo because some shells will issue
warnings for invalid locales.
