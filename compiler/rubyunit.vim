" Vim compiler file
" Language:	Test::Unit - Ruby Unit Testing Framework
" Maintainer:	Doug Kearns <djkea2 at mugca.its.monash.edu.au>
" Info:		$Id: rubyunit.vim,v 1.2 2004/05/11 08:29:23 dkearns Exp $
" URL:		http://vim-ruby.sourceforge.net
" Anon CVS:	See above site
" Licence:	GPL (http://www.gnu.org)
" Disclaimer:
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
" ----------------------------------------------------------------------------

if exists("current_compiler")
  finish
endif
let current_compiler = "rubyunit"

let s:cpo_save = &cpo
set cpo-=C

setlocal makeprg=ruby

setlocal errorformat=\%Etest%[%^\ ]%#(%[%^\ ]%#)\ [%f:%l]:,
		     \%E\ %\\+%f:%l:in\ %.%#,
		     \%Z%m%\\%.,
		     \%-GLoaded%.%#,
		     \%-GStarted%.%#,
		     \%-G%[EF%.]%.%#,
		     \%-GFinished\ in%.%#,
		     \%-G\ %\\+%\\d%\\+)\ Failure:,
		     \%-G\ %\\+%\\d%\\+)\ Error:

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap ts=8 ff=unix