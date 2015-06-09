/*  wrapper.c  */

#define REAL_PATH "/usr/local/bin/private/sendmail.pl"

      main(ac, av)
          char **av;

      {
          execv(REAL_PATH, av);
      }