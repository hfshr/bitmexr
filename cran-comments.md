# Testing environments

MacOS (release and devel, on GitHub Actions)
Ubuntu 20.04 (release on GitHub Action and rhub)
Rhub: Windows Server 2008 R2 SP1 (R-devel) 

# R CMD check results

0 errors | 0 warnings | 2 notes

* ONLY on Fedora Linux (R-hub): checking HTML version of manual ... NOTE Skipping checking HTML validation: no command 'tidy' found. I cannot change that Tidy is not on the path, or update Tidy on the external Fedora Linux server.

* Only on Windows (Server 2022, R-devel 64-bit):

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.


# Reverse dependency check

No problems
