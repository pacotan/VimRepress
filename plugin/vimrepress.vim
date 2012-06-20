"#######################################################################
" Copyright (C) 2007 Adrien Friggeri.
"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2, or (at your option)
" any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software Foundation,
" Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
" 
" Contributors:	Adrien Friggeri <adrien@friggeri.net>
"               Pigeond <http://pigeond.net/blog/>
"               Justin Sattery <justin.slattery@fzysqr.com>
"               Lenin Lee <lenin.lee@gmail.com>
"               Conner McDaniel <connermcd@gmail.com>
"
" Forked By: Preston M.[BOYPT] <pentie@gmail.com>
" Repository: https://bitbucket.org/pentie/vimrepress
"
" URL:		http://www.friggeri.net/projets/vimblog/
"           http://pigeond.net/blog/2009/05/07/vimpress-again/
"           http://pigeond.net/git/?p=vimpress.git
"           http://fzysqr.com/
"           http://apt-blog.net
"
" VimRepress 
"    - A mod of a mod of a mod of Vimpress.   
"    - A vim plugin fot writting your wordpress blog.
"    - Write with Markdown, control posts format precisely.
"    - Stores Markdown rawtext in wordpress custom fields.
"
" Version:	3.2.1
"
" Config: Create account configure as `~/.vimpressrc' in the following
" format:
"
"[Blog0]
"blog_url = http://a-blog.com/
"username = admin
"password = 123456
"
"[Blog1]
"blog_url = https://someone.wordpress.com/
"username = someone
"password =
"
"#######################################################################

if !has("python")
    finish
endif

function! CompSave(ArgLead, CmdLine, CursorPos)
  return "publish\ndraft\n"
endfunction

function! CompPrev(ArgLead, CmdLine, CursorPos)
  return "local\npublish\ndraft\n"
endfunction

function! CompEditType(ArgLead, CmdLine, CursorPos)
  return "post\npage\n"
endfunction

let s:py_loaded = 0
let s:vimpress_dir = fnamemodify(expand("<sfile>"), ":p:h")

function! PyCMD(pyfunc)
    if (s:py_loaded == 0)
        exec("cd " . s:vimpress_dir)
        let s:pyfile = fnamemodify("vimrepress.py", ":p")
        exec("cd -")
        exec("pyfile " . s:pyfile)
        let s:py_loaded = 1
    endif
    exec('python ' . a:pyfunc)
endfunction

command! -nargs=? -complete=custom,CompEditType BlogList call PyCMD('blog_list(<f-args>)')
command! -nargs=? -complete=custom,CompEditType BlogNew call PyCMD('blog_new(<f-args>)')
command! -nargs=? -complete=custom,CompSave BlogSave call PyCMD('blog_save(<f-args>)')
command! -nargs=? -complete=custom,CompPrev BlogPreview call PyCMD('blog_preview(<f-args>)')
command! -nargs=1 -complete=file BlogUpload call PyCMD('blog_upload_media(<f-args>)')
command! -nargs=1 BlogOpen call PyCMD('blog_guess_open(<f-args>)')
command! -nargs=? BlogSwitch call PyCMD('blog_config_switch(<f-args>)')
command! -nargs=? BlogCode call PyCMD('blog_append_code(<f-args>)')
